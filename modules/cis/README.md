# terraform-aws-cis-controls
AWS CIS Controls v1.5.0 module for terraform

### Controls covered by cloudtrail module:

- 3.1 Ensure CloudTrail is enabled in all regions
- 3.2 Ensure CloudTrail log file validation is enabled
- 3.3 Ensure the S3 bucket used to store CloudTrail logs is not publicly accessible
- 3.4 Ensure CloudTrail trails are integrated with Amazon CloudWatch Logs
- 3.6 Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket
- 3.7 Ensure CloudTrail logs are encrypted at rest using AWS KMS CMKs
- 
- 4.1 – Ensure a log metric filter and alarm exist for unauthorized API calls
- 4.2 – Ensure a log metric filter and alarm exist for AWS Management Console sign-in without MFA
- 4.3 – Eliminate use of the root user for administrative and daily tasks
- 4.4 – Ensure a log metric filter and alarm exist for IAM policy changes
- 4.5 – Ensure a log metric filter and alarm exist for CloudTrail configuration changes
- 4.6 – Ensure a log metric filter and alarm exist for AWS Management Console authentication failures
- 4.7 – Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer managed keys
- 4.8 – Ensure a log metric filter and alarm exist for S3 bucket policy changes
- 4.9 – Ensure a log metric filter and alarm exist for AWS Config configuration changes
- 4.10 – Ensure a log metric filter and alarm exist for security group changes
- 4.11 – Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL)
- 4.12 – Ensure a log metric filter and alarm exist for changes to network gateways
- 4.13 – Ensure a log metric filter and alarm exist for route table changes
- 4.14 – Ensure a log metric filter and alarm exist for VPC changes
- 4.15 Ensure a log metric filter and alarm exists for AWS Organizations changes

### Controls covered by config modules (config and config-aggregator):
- 1.4 Ensure no 'root' user account access key exists
- 1.5 Ensure MFA is enabled for the 'root' user account
- 1.8 Ensure IAM password policy requires a minimum length of 14 or greater
- 1.9 Ensure IAM password policy prevents password reuse
- 1.10 Ensure multi-factor authentication (MFA) is enabled for all IAM users that have a console password
- 1.14 Ensure access keys are rotated every 90 days or less
- 1.16 Ensure IAM policies that allow full "*:*" administrative privileges are not attached

- 2.1.1 Ensure all S3 buckets employ encryption-at-rest
- 2.1.2 Ensure S3 Bucket Policy is set to deny HTTP requests
- 2.1.5 Ensure that S3 Buckets are configured with 'Block public access (bucket settings)'

- 2.2.1 Ensure EBS Volume Encryption is Enabled in all Regions

- 2.3.1 Ensure that encryption is enabled for RDS Instances
- 2.3.3 Ensure that public access is not given to RDS Instance 

- 2.4.1 Ensure that encryption is enabled for EFS file systems

- 3.1 Ensure CloudTrail is enabled in all regions
- 3.2 Ensure CloudTrail log file validation is enabled
- 3.4 Ensure CloudTrail trails are integrated with Amazon CloudWatch Logs
- 3.5 Ensure AWS Config is enabled in all regions
- 3.7 Ensure CloudTrail logs are encrypted at rest using AWS KMS CMKs

- 5.1 Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports
- 5.4 Ensure the default security group of every VPC restricts all traffic


### Controls covered by general module:
- 1.8 Ensure IAM password policy requires a minimum length of 14 or greater
- 1.9 Ensure IAM password policy prevents password reuse
- 
- 4.16 Ensure AWS Security Hub is enabled
