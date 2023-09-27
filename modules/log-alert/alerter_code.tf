data "archive_file" "code" {
  type        = "zip"
  output_path = "${path.module}/alerter.zip"
  source_content_filename = "alerter.py"
  source_content = <<EOF
import base64
import json
import os
import zlib
from datetime import datetime

import boto3

sns = boto3.client('sns')
topic = os.environ['SNS_ALERT_TOPIC']
subject = os.environ['SUBJECT']


def handler(event, context):
    payload = base64.b64decode(event['awslogs']['data'])
    unzipped_payload = zlib.decompress(payload, 16 + zlib.MAX_WBITS)
    log_event = json.loads(unzipped_payload)

    formatted_messages = format_messages(log_event.get('logEvents', []))

    response = sns.publish(
        TopicArn=topic,
        Message=formatted_messages,
        Subject=subject
    )

    print("Sns Message:", json.dumps(response, indent=2))

    return {
        'statusCode': 200,
        'body': json.dumps('Successfully sent message with message id: ' + response.get('MessageId'))
    }


def format_messages(log_events):
    formatted_messages = ['Log Events:']
    for event in log_events:
        timestamp = datetime.utcfromtimestamp(event['timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
        message = f"--- (id: {event['id']}) \n [{timestamp} UTC]: [{event['message']}] \n"
        formatted_messages.append(message)
    return '\n'.join(formatted_messages)
EOF
}
