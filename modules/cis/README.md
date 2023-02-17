# terraform-aws-cis-controls
AWS CIS Controls v1.5.0 module for terraform

### Controls covered by cloudtrail module:

- 3.1 Ensure CloudTrail is enabled in all regions
- 3.2 Ensure CloudTrail log file validation is enabled
- 3.3 Ensure the S3 bucket used to store CloudTrail logs is not publicly accessible
- 3.4 Ensure CloudTrail trails are integrated with Amazon CloudWatch Logs
- 3.6 Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket
- 3.7 Ensure CloudTrail logs are encrypted at rest using AWS KMS CMKs
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
- 4.16 Ensure AWS Security Hub is enabled

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


### Controls covered by general modules:
- 1.8 Ensure IAM password policy requires a minimum length of 14 or greater
- 1.9 Ensure IAM password policy prevents password reuse


```terraform
module "cloutrail-aws-cis-compliant" {
  source = "git@github.com:in4it/terraform-modules.git//modules/cis/cis-cloudtrail"
  count  = var.env == "central" ? 1 : 0

  aws_account_id  = var.aws_account_id
  company_name    = "acmecorp"
  organization_id = var.organization_id
  env             = var.env
}
module "cloutrail-alarms-aws-cis-compliant" {
  source = "git@github.com:in4it/terraform-modules.git//modules/cis/cis-log-alarms"
  count  = var.env == "central" ? 1 : 0


  company_name            = "acmecorp"
  env                     = var.env
  existing_log_group_name = module.cloutrail-aws-cis-compliant.0.cloudtrail_log_group_name
  alarm_namespace         = "LogMetrics"
  sns_arn                 = aws_sns_topic.acmecorp-cis-alarms-topic.0.arn
}

resource "aws_sns_topic" "acmecorp-cis-alarms-topic" {
  count = var.env == "central" ? 1 : 0

  name = "acmecorp-cis-alarms-${var.env}"
}

module "aws-cis-compliant-general-resources" {
  source = "git@github.com:in4it/terraform-modules.git//modules/cis/cis-general"

  company_name               = "acmecorp"
  env                        = var.env
}

module "aws-cis-compliant-general-org-resources" {
  source     = "git@github.com:in4it/terraform-modules.git//modules/cis/cis-general-organization"
  count      = var.env == "central" ? 1 : 0
  depends_on = [module.aws-cis-compliant-general-resources]

  aws_account_id = var.aws_account_id
  company_name   = "acmecorp"
  env            = var.env
  security_hub_members = {
    "team+dev@acmecorp.com" : "123456789800"
    "team+qa@acmecorp.com" : "123456789800"
    "team+staging@acmecorp.com" : "123456789800"
    "team+prod@acmecorp.com" : "123456789800"
  }
}

resource "aws_sns_topic" "acmecorp-cis-config-topic" {
  name = "acmecorp-cis-config-${var.env}"
}

module "aws-cis-compliant-config-resources" {
  source = "git@github.com:in4it/terraform-modules.git//modules/cis/cis-config"

  company_name = "acmecorp"
  env          = var.env
  sns_arn      = aws_sns_topic.acmecorp-cis-config-topic.arn

# These configs are FALSE by default, but you can enable them if you want custom configs. 
  configs_check_iam_root_access_key                           = true 
  configs_check_iam_password_policy                           = true
  configs_check_root_account_mfa_enabled                      = true
  configs_check_access_keys_rotated                           = true
  configs_check_mfa_enabled_for_iam_console_access            = true
  configs_check_multi_region_cloud_trail                      = true
  configs_check_cloud_trail_encryption                        = true
  configs_check_cloudtrail_enabled                            = true
  configs_check_cloud_trail_log_file_validation               = true
  configs_cloud_trail_cloud_watch_logs_enabled                = true
  configs_check_s3_bucket_level_public_access_prohibited      = true
  configs_check_s3_bucket_ssl_requests_only                   = true
  configs_check_s3_bucket_server_side_encryption_enabled      = true
  configs_check_ec2_encrypted_volumes                         = true
  configs_check_rds_public_access                             = true
  configs_check_rds_storage_encrypted                         = true
  configs_enable_efs_encrypted_check                          = true
  configs_check_iam_policy_no_statements_with_admin_access    = true
  configs_check_iam_policy_no_statements_with_full_access     = true
  configs_check_nacl_no_unrestricted_ssh_rdp                  = true
  configs_check_vpc_default_security_group_closed             = true

# These configs are FALSE by default and add all resources, if you want to use custom fill as example below, check the resource types that your environment needs on this link: https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html

  configs_include_global_resource_types = true
  configs_resource_types   = [  
      "AWS::ApiGateway::Stage",
      "AWS::ApiGateway::RestApi",
      "AWS::ApiGatewayV2::Stage",
      "AWS::ApiGatewayV2::Api",
      "AWS::EC2::NetworkAcl",
      "AWS::EC2::SecurityGroup",
      "AWS::DynamoDB::Table",
      "AWS::ACM::Certificate",
      "AWS::CloudTrail::Trail",
      "AWS::Config::ResourceCompliance",
      "AWS::ECR::RegistryPolicy",
      "AWS::ECR::Repository",
      "AWS::ECS::Cluster",
      "AWS::ECS::Service",
      "AWS::ECS::TaskDefinition",
      "AWS::EKS::Cluster",
      "AWS::EKS::FargateProfile",
      "AWS::EMR::SecurityConfiguration",
      "AWS::ElasticLoadBalancing::LoadBalancer",
      "AWS::ElasticLoadBalancingV2::Listener",
      "AWS::ElasticLoadBalancingV2::LoadBalancer",
      "AWS::Glue::Classifier",
      "AWS::Glue::Job",
      "AWS::IAM::Group",
      "AWS::IAM::Policy",
      "AWS::IAM::Role",
      "AWS::IAM::User",
      "AWS::KMS::Key",
      "AWS::Kinesis::Stream",
      "AWS::Kinesis::StreamConsumer",
      "AWS::Lambda::Function",
      "AWS::NetworkFirewall::Firewall",
      "AWS::NetworkFirewall::FirewallPolicy",
      "AWS::NetworkFirewall::RuleGroup",
      "AWS::Elasticsearch::Domain",
      "AWS::OpenSearch::Domain",
      "AWS::RDS::DBCluster",
      "AWS::RDS::DBClusterSnapshot",
      "AWS::RDS::DBInstance",
      "AWS::RDS::DBSecurityGroup",
      "AWS::RDS::DBSnapshot",
      "AWS::RDS::DBSubnetGroup",
      "AWS::RDS::EventSubscription",
      "AWS::S3::AccountPublicAccessBlock",
      "AWS::S3::Bucket",
      "AWS::SSM::AssociationCompliance",
      "AWS::SSM::FileData",
      "AWS::SSM::ManagedInstanceInventory",
      "AWS::SSM::PatchCompliance",
      "AWS::SQS::Queue",
      "AWS::SecretsManager::Secret",
      "AWS::WAFRegional::RateBasedRule",
      "AWS::WAFRegional::Rule",
      "AWS::WAFRegional::RuleGroup",
      "AWS::WAFRegional::WebACL",
      "AWS::WAFv2::IPSet",
      "AWS::WAFv2::ManagedRuleSet",
      "AWS::WAFv2::RegexPatternSet",
      "AWS::WAFv2::RuleGroup",
      "AWS::WAFv2::WebACL",
    ]
  }
}
module "aws-cis-compliant-config-aggregator-resources" {
  source = "git@github.com:in4it/terraform-modules.git//modules/cis/cis-config-aggregator"
  count  = var.env == "central" ? 1 : 0

  company_name = "acmecorp"
  env          = var.env
}
```
