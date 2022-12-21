module "cloutrail-aws-cis-compliant" {
  source = "./cis-cloudtrail"
  count  = var.env == "billing" ? 1 : 0

  aws_account_id  = var.aws_account_id
  company_name    = var.company_name
  organization_id = var.organization_id
  env             = var.env

  existing_bucket_id  = var.existing_bucket_id
  use_existing_bucket = var.use_existing_bucket
}
module "cloutrail-alarms-aws-cis-compliant" {
  source = "./cis-log-alarms"
  count  = var.env == "billing" ? 1 : 0


  company_name            = var.company_name
  env                     = var.env
  existing_log_group_name = module.cloutrail-aws-cis-compliant.0.cloudtrail_log_group_name
  alarm_namespace         = "LogMetrics"
  sns_arn                 = var.sns_arn
}

module "aws-cis-compliant-general-resources" {
  source = "./cis-general"

  company_name = var.company_name
  env          = var.env

  iam_allow_users_to_change_password = var.iam_allow_users_to_change_password
  iam_hard_expiry                    = var.iam_hard_expiry
  iam_require_uppercase_characters   = var.iam_require_uppercase_characters
  iam_require_lowercase_characters   = var.iam_require_lowercase_characters
  iam_require_symbols                = var.iam_require_symbols
  iam_require_numbers                = var.iam_require_numbers
  iam_minimum_password_length        = var.iam_minimum_password_length
  iam_password_reuse_prevention      = var.iam_password_reuse_prevention
  iam_max_password_age               = var.iam_max_password_age
}

module "aws-cis-compliant-general-org-resources" {
  source = "./cis-general-organization"
  count  = var.env == "billing" ? 1 : 0

  company_name   = var.company_name
  env            = var.env
  aws_account_id = var.aws_account_id
}

module "aws-cis-compliant-config-resources" {
  source = "./cis-config"

  company_name = var.company_name
  env          = var.env
  sns_arn      = var.sns_arn


}
module "aws-cis-compliant-config-aggregator-resources" {
  source = "./cis-config-aggregator"
  count  = var.env == "billing" ? 1 : 0

  company_name = var.company_name
  env          = var.env
}