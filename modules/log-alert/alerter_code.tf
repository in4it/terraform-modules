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
show_as_table = os.environ.get('SHOW_AS_TABLE', 'False').lower() == 'true'

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
    formatted_messages = format_as_table(log_events, cloudwatch_link) if show_as_table else format_as_text(log_events, cloudwatch_link)

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


def format_as_text(events, logstream_link):
    formatted_messages = ['CloudWatch Log Stream:', logstream_link, '\n']
    for event in events:
        timestamp = datetime.utcfromtimestamp(event['timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
        message = f"--- \n (id: {event['id']}) \n [{timestamp} UTC]: [{event['message']}] \n --- \n"
        formatted_messages.append(message)
    return '\n'.join(formatted_messages)

def format_as_table(events, logstream_link):
    messages = ['CloudWatch Log Stream:', logstream_link, '\n', '<table border="1">', '<tr><th>ID</th><th>Timestamp</th><th>Message</th></tr>']

    for event in events:
        log_id = event['id']
        timestamp = datetime.utcfromtimestamp(event['timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S UTC')
        message = event['message']
        messages.append(f'<tr><td>{log_id}</td><td>{timestamp}</td><td>{message}</td></tr>')

    messages.append('</table>')
    return ''.join(messages)
EOF
}
