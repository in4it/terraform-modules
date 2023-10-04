data "archive_file" "code" {
  type        = "zip"
  output_path = "${path.module}/alerter.zip"
  source_content_filename = "alerter.py"
  source_content = <<EOF
import os
import base64
import json
import zlib
from datetime import datetime
import boto3

topic = os.environ['SNS_ALERT_TOPIC']
subject = os.environ['SUBJECT']

session = boto3.session.Session()
region = session.region_name
sns = session.client('sns')


def handler(event, context):
    payload = base64.b64decode(event['awslogs']['data'])
    unzipped_payload = zlib.decompress(payload, 16 + zlib.MAX_WBITS)
    log_event = json.loads(unzipped_payload)

    log_group = log_event.get('logGroup')
    log_stream = log_event.get('logStream')
    cloudwatch_link = f"https://{region}.console.aws.amazon.com/cloudwatch/home?region={region}#logsV2:log-groups/log-group/{log_group}/log-events/{log_stream}"

    log_events = log_event.get('logEvents', [])
    formatted_messages = format_events(log_events, cloudwatch_link)

    response = sns.publish(
        TopicArn=topic,
        Message=formatted_messages,
        Subject=subject
    )

    print("Sns Response:", json.dumps(response, indent=2))

    return {
        'statusCode': 200,
        'body': json.dumps('Successfully sent SNS message with message id: ' + response.get('MessageId'))
    }


def format_events(events, logstream_link):
    formatted_messages = ['CloudWatch Log Stream:', logstream_link, '\n']
    for event in events:
        timestamp = datetime.utcfromtimestamp(event['timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
        message = f"--- \n (id: {event['id']}) \n [{timestamp} UTC]: [{event['message']}] \n --- \n"
        formatted_messages.append(message)
    return '\n'.join(formatted_messages)
EOF
}
