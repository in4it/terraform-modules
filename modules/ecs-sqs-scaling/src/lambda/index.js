// =============================================================================
// Lambda function that generates a custom backlog Cloudwatch metric for multiple ECS worker services that processes messages from SQS queues.
// The function is triggered by a Cloudwatch Event Rule that runs on a period.
// As input the function expects a CONFIG json object with the following structure:
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
// 1) Gets the SQS queue info - url + attributes.
// 2) Gets the number of ECS tasks that are running and pending.
// 3) Calculates the backlog metric as the number of messages in the queue divided by the number of ECS tasks.
// 4) Publishes the backlog metric to Cloudwatch.

const { checkEnvs } = require("./functions");
const {
  SQSClient,
  GetQueueUrlCommand,
  GetQueueAttributesCommand,
} = require("@aws-sdk/client-sqs");
const { ECSClient, DescribeServicesCommand } = require("@aws-sdk/client-ecs");
const {
  CloudWatchClient,
  PutMetricDataCommand,
} = require("@aws-sdk/client-cloudwatch");

exports.handler = async (event) => {
  checkEnvs(["CONFIG", "ENV", "CUSTOM_METRIC_NAMESPACE", "CUSTOM_METRIC_NAME"]);
  const debugMode = process.env.DEBUG == "true" ? true : false;
  const CONFIG = JSON.parse(process.env.CONFIG);
  console.log(process.env.AWS_REGION);
  const results = {
    success: [],
    failed: [],
  };
  const sqsClient = new SQSClient({ region: process.env.AWS_REGION });
  const ecsClient = new ECSClient({ region: process.env.AWS_REGION });
  const cwClient = new CloudWatchClient({ region: process.env.AWS_REGION });

  for (const [serviceName, config] of Object.entries(CONFIG)) {
    try {
      const data = {};
      console.log("Processing service:", serviceName);
      console.log("config:", config);

      // Get Queue details
      const res = await sqsClient.send(
        new GetQueueUrlCommand({
          QueueName: config.tracking_sqs_queue,
        })
      );
      data.queueUrl = res.QueueUrl;

      const res2 = await sqsClient.send(
        new GetQueueAttributesCommand({
          QueueUrl: data.queueUrl,
          AttributeNames: [config.tracking_sqs_queue_metric],
        })
      );
      data.sqsAttributes = res2.Attributes;
      console.log("res2:", res2);
      console.log("data.sqsAttr:", data.sqsAttributes);
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

      // Skip Cloudwatch publish if in debug mode for testing
      if (debugMode) {
        console.log("[DEBUG MODE] Skipping Cloudwatch metric publish");
        continue;
      }
      await cwClient.send(new PutMetricDataCommand(metric));

      results.success.push({ serviceName, data, backlog });
    } catch (error) {
      results.failed.push({ serviceName, error });
    }
  }
  console.log(results);
  if (results.failed.length > 0) {
    throw new Error(`Failed to process some services ${results.failed}`);
  }
  return results;
};
