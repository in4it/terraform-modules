data "archive_file" "continuous-replica" {
  type        = "zip"
  output_path = "${path.module}/continuous.zip"
  source_content_filename = "continuous.py"
  source_content = <<EOF
import os
import boto3

TARGET_REGION = os.environ.get('TARGET_REGION')

source_ssm = boto3.client('ssm')
target_ssm = boto3.client('ssm', region_name=TARGET_REGION)

def check_target(event):
    try:
        # Check if target exists already
        return target_ssm.get_parameter(
            Name=event['detail']['name'],
            WithDecryption=True
        )
    except target_ssm.exceptions.ParameterNotFound:
        return None
    except Exception as e:
        raise e

def update(event):
    source_param = source_ssm.get_parameter(
        Name=event['detail']['name'],
        WithDecryption=True
    )

    target_param = check_target(event)
    if not target_param or target_param['Parameter']['Value'] != source_param['Parameter']['Value'] or target_param['Parameter']['Type'] != source_param['Parameter']['Type']:
        print(f"Overwrite {event['detail']['name']}")
        source_param['Parameter'].pop('Version')
        source_param['Parameter'].pop('ARN')
        source_param['Parameter'].pop('LastModifiedDate')
        source_param['Parameter']['Overwrite'] = True
        return target_ssm.put_parameter(**source_param['Parameter'])
    else:
        print(f"Parameter {event['detail']['name']} is already in {TARGET_REGION} with the same value and type, ignoring")
        return None

def remove(event):
    print(f"Remove {event['detail']['name']}")
    try:
        return target_ssm.delete_parameter(
            Name=event['detail']['name']
        )
    except target_ssm.exceptions.ParameterNotFound:
        print(f"Parameter {event['detail']['name']} was not found in {TARGET_REGION}, ignoring")
        return None
    except Exception as e:
        raise e

operations = {
    "Create": update,
    "Update": update,
    "Delete": remove
}

def handle_ssm_event(event):
    print("SSM event received")
    try:
        operation = event['detail']['operation']
        if operation in operations:
            success = operations[operation](event)
            if success:
                print(f"{operation} result:\n{success}")
        else:
            print(f"Unknown operation \"{operation}\":\n{event}")
    except Exception as e:
        print(f"Operation failed for\n{event}\n{e}")
        if getattr(e, 'retryable', False):
            raise e
    return 'OK'

def handle_sqs_event(event):
    print("SQS event received")
    for record in event["Records"]:
        print(f"Copy {record['body']}")
        update({"detail": {"name": record["body"]}})

def handler(event, context):
    print(event)
    if "Records" in event:
        handle_sqs_event(event)
    elif "detail-type" in event:
        handle_ssm_event(event)
    else:
        print("Unknown event type")
        return
EOF
}
