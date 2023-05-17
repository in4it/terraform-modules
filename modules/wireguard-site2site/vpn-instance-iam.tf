resource "aws_iam_instance_profile" "vpn_iam_instance_profile" {
  name = "${var.identifier}-vpn-iam-instance-profile-${var.env}"
  role = aws_iam_role.vpn-iam-role.name
}

resource "aws_iam_role" "vpn-iam-role" {
  name = "${var.identifier}-vpn-iam-role-${var.env}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vpn-iam-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.vpn-iam-role.id
}

resource "aws_iam_role_policy" "vpn-custom-policy" {
  policy = data.aws_iam_policy_document.vpn-custom-policy.json
  role   = aws_iam_role.vpn-iam-role.id
}
data "aws_iam_policy_document" "vpn-custom-policy" {
  statement {
    actions = [
      "ssm:GetParametersByPath",
      "ssm:PutParameter",
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.identifier}-vpn-${var.env}/",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.identifier}-vpn-${var.env}/*"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
    ]
    effect    = "Allow"
    resources = [aws_kms_key.vpn-ssm-key.arn]
  }
}
