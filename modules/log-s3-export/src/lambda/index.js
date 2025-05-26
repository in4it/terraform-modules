const {
  CloudWatchLogsClient,
  CreateExportTaskCommand,
  DescribeExportTasksCommand,
} = require("@aws-sdk/client-cloudwatch-logs");

const {
  sleep,
  getExportStatus,
  calcPrefix,
  checkEnvs,
} = require("./functions");

const cwLogs = new CloudWatchLogsClient();

exports.handler = async function (event, context) {
  // Get env variables
  checkEnvs(["EXPORT_BUCKET", "LOG_GROUPS", "BUCKET_PREFIX"]);

  const EXPORT_BUCKET = process.env.EXPORT_BUCKET;
  const LOG_GROUPS = JSON.parse(process.env.LOG_GROUPS); // Array of log groups
  const BUCKET_PREFIX = process.env.BUCKET_PREFIX;
  const DAYS_BEFORE = process.env.DAYS_BEFORE || 1;
  const RETRY = process.env.RETRY || 5;
  const RETRY_TIMEOUT = process.env.RETRY_TIMEOUT || 5;

  const results = {
    success: [],
    failed: [],
    timeout: [],
  };

  // Set date objects
  var today = new Date();
  today.setUTCHours(0, 0, 0, 0);
  var fromDate = new Date(today);
  fromDate.setDate(today.getDate() - DAYS_BEFORE);

  // For each log group create export task
  for (const logGroup of LOG_GROUPS) {
    const parsedName = logGroup.replace(/\//g, ".");
    const prefix = calcPrefix(BUCKET_PREFIX, parsedName, today);

    const params = {
      destination: EXPORT_BUCKET, // required
      from: +fromDate, // required
      logGroupName: logGroup, // required
      to: +today, // required
      destinationPrefix: prefix,
      taskName: `export-${parsedName}`,
    };

    try {
      // Create export task using v3 SDK command pattern
      const command = new CreateExportTaskCommand(params);
      const res = await cwLogs.send(command);
      console.log(`> Created exported task for ${logGroup}`);

      // Status checking, with retry logic
      for (let i = 0; i < RETRY; i++) {
        // Wait some seconds for it to complete
        await sleep(RETRY_TIMEOUT);

        console.log(`> Checking Status.. try No.${i}`);
        let currentStatus = await getExportStatus(res.taskId, cwLogs);
        console.log(currentStatus);

        if (["FAILED", "CANCELLED"].includes(currentStatus)) {
          throw new Error("Export status is FAILED or CANCELLED");
        }
        if (currentStatus == "COMPLETED") {
          results.success.push(logGroup);
          break;
        }
        if (i == RETRY - 1) {
          results.timeout.push(logGroup);
        }
      }
    } catch (error) {
      console.log(`[X] ERROR exporting task ${logGroup}`, error);
      results.failed.push(logGroup);
    }
    await sleep(0.25); // Sleep to avoid throttling
  }

  console.log("> Lambda Task Completed: ", results);

  if (results.failed.length > 0) {
    throw new Error("Some tasks failed");
  }

  return results;
};
