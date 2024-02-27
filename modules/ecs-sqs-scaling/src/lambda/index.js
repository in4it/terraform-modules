// Lambda function that generates a custom backlog Cloudwatch metric for an ECS worker service that processes messages from an SQS queue.
// The function is triggered by a Cloudwatch Event Rule that runs every minute.
// As input the function expects a CONFIG json array with the following object structure:
//
//  {
//     "servicea": {
//         "ecs_service": "my-serviceA",
//         "ecs_cluster": "my-cluster",
//         "tracking_sqs_queue": "my-queue",
//         "tracking_sqs_queue_metric": "ApproximateNumberOfMessages",
//     },
//     ...
// }
// For each service, the function:
// 1) Gets the number of messages in the SQS queue.
// 2) Gets the number of ECS tasks that are running and pending.
// 3) Calculates the backlog metric as the number of messages in the queue divided by the number of ECS tasks.
// 4) Publishes the backlog metric to Cloudwatch.

import {
  SQSClient,
  GetQueueUrlCommand,
  GetQueueAttributes,
} from "@aws-sdk/client-sqs";
import { ECSClient, DescribeServicesCommand } from "@aws-sdk/client-ecs";
import {
  CloudWatchClient,
  PutMetricDataCommand,
} from "@aws-sdk/client-cloudwatch";
const { checkEnvs } = require("./functions");

exports.handler = async (event) => {
  checkEnvs(["CONFIG", "ENV", "CUSTOM_METRIC_NAMESPACE", "CUSTOM_METRIC_NAME"]);

  const CONFIG = JSON.parse(event.CONFIG);

  const results = {
    success: [],
    failed: [],
  };
  const sqsClient = new SQSClient({ region: process.env.AWS_REGION });
  const ecsClient = new ECSClient({ region: process.env.AWS_REGION });
  const cloudwatchClient = new CloudWatchClient({
    region: process.env.AWS_REGION,
  });

  for (const [serviceName, config] of Object.entries(CONFIG)) {
    try {
      const data = {};

      // Get Queue details
      const res = await sqsClient.send(
        new GetQueueUrlCommand({ QueueName: config.tracking_sqs_queue })
      );
      data.queueUrl = res.QueueUrl;

      const res2 = await sqsClient.send(
        new GetQueueAttributes({ QueueUrl: data.queueUrl })
      );
      data.sqsAttributes = res2.Attributes;

      // Get ECS Service details
      const res3 = await ecsClient.send(
        new DescribeServicesCommand({
          cluster: config.ecs_cluster,
          services: [config.ecs_service],
        })
      );
      data.service = res3.services[0];

      const trackingMetric =
        data.sqsAttributes[config.tracking_sqs_queue_metric];
      const runningCount = data.service.runningCount;
      const pendingCount = data.service.pendingCount;
      const taskCount = runningCount + pendingCount;

      // Calculate backlog
      const backlog = trackingMetric / taskCount;

      console.log("data:", data);
      console.log("trackingMetric:", trackingMetric);
      console.log("taskCount:", taskCount);

      // Create Cloudwatch metric
      const metric = {
        MetricData: [
          {
            MetricName: process.env.CUSTOM_METRIC_NAME,
            Dimensions: [
              {
                Name: "Cluster",
                Value: config.ecs_cluster,
              },
              {
                Name: "Service",
                Value: serviceName,
              },
              {
                Name: "Queue",
                Value: config.tracking_sqs_queue,
              },
            ],
            Unit: "Count",
            Value: backlog,
          },
        ],
        Namespace: process.env.CUSTOM_METRIC_NAMESPACE,
      };
      console.log(metric);

      if (process.env.ENV == "DEBUG") {
        console.log("[DEBUG MODE] Skipping Cloudwatch metric publish");
        continue;
      }
      await cloudwatchClient.send(new PutMetricDataCommand(metric));

      results.success.push({ serviceName, data, backlog });
    } catch (error) {
      results.failed.push({ serviceName, error });
    }
  }
  console.log(results);
  return results;
};
