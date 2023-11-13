resource "aws_kms_key" "terraform-state" {
  count                   = var.kms-encryption ? 1 : 0
  description             = "KMS key to encrypt Terraform state"
  deletion_window_in_days = var.kms-deletion-window
}

resource "aws_kms_alias" "terraform-state" {
  count         = var.kms-encryption ? 1 : 0
  name          = "alias/${var.project}-${var.env}-terraform-state"
  target_key_id = aws_kms_key.terraform-state[0].key_id
}

resource "aws_kms_key_policy" "terraform_state" {
  count  = var.kms-encryption && length(var.principals) > 0 ? 1 : 0
  key_id = aws_kms_key.terraform-state[0].id
  policy = data.aws_iam_policy_document.terraform-state.json
}

data "aws_iam_policy_document" "terraform-state" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    dynamic "principals" {
      for_each = var.principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}
