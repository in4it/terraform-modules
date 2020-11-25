resource "aws_iam_instance_profile" "bastion" {
  name = replace(var.name, " ", "-")
  role = aws_iam_role.bastion.name
}

data "aws_iam_policy_document" "bastion_role_assume_role_policy"{
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  name               = replace(var.name, " ", "-")
  assume_role_policy = data.aws_iam_policy_document.bastion_role_assume_role_policy.json
}

