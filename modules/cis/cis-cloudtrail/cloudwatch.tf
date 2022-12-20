
resource "aws_cloudwatch_log_group" "global-trail" {
  name              = "${var.company_name}-global-trail"
  retention_in_days = 7
}

resource "aws_iam_role" "global-trail-cw-logs-role" {
  name               = "${var.company_name}-global-trail-cw-logs-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.global-trail-cw-logs-assume-role-policy.json
}

data "aws_iam_policy_document" "global-trail-cw-logs-assume-role-policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "global-trail-cw-logs-role" {
  policy = data.aws_iam_policy_document.global-trail-cw-logs-policy.json
  role   = aws_iam_role.global-trail-cw-logs-role.id
}

data "aws_iam_policy_document" "global-trail-cw-logs-policy" {

  statement {
    sid    = "AWSCloudTrailCreateLogStream"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.global-trail.arn}:*",
    ]
  }
}
