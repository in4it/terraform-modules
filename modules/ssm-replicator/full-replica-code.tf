data "archive_file" "full-replica" {
  type        = "zip"
  output_path = "${path.module}/full.zip"
  source_content_filename = "full.py"
  source_content = <<EOF
import os
import time

import boto3

queue_url = os.environ.get('QUEUE_URL')
sqs_client = boto3.client('sqs')
ssm_client = boto3.client('ssm')

def handler(event, context):
    next_token = ""
    count = 0

    while True:
        try:
            describe_batch = ssm_client.describe_parameters(ParameterFilters=[{
                        'Key': 'Type',
                        'Values': ['String', 'StringList', 'SecureString']}
                ],
                NextToken=next_token
            )
            for item in describe_batch['Parameters']:
                sqs_client.send_message(
                  QueueUrl=queue_url,
                  MessageBody=item['Name'])

            if 'NextToken' not in describe_batch:
                break
            next_token = describe_batch['NextToken']
            count+=len(describe_batch['Parameters'])
        except ssm_client.exceptions.ParameterLimitExceeded:
            print("Sleeping for 60 seconds while describing parameters.")
            time.sleep(60)

    print(f"Handled {count} parameters")
    return count
EOF
}
