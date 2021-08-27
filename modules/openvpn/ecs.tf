module "ecs-cluster" {
  source                = "git@github.com:in4it/terraform-modules.git//modules/fargate-cluster"
  cluster_name          = "${var.project_name}}-vpn-${var.env}"
  log_group             = "${var.project_name}}-vpn-${var.env}"
  execution_role_policy = data.aws_iam_policy_document.ecs_execution_role.json
}

data "aws_iam_policy_document" "ecs_execution_role" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      module.ssm-parameters-vpn.kms-key-arn,
      "arn:aws:kms:${var.aws_region}:${var.aws_account_id}:alias/ssm-paramstore-${var.project_name}}-${var.env}vpn"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.project_name}-${var.env}/vpn/*"
    ]
  }
}