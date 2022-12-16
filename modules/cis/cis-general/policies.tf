
resource "aws_iam_account_password_policy" "cis" {
  require_uppercase_characters = var.iam_require_uppercase_characters
  require_lowercase_characters = var.iam_require_lowercase_characters
  require_symbols              = var.iam_require_symbols
  require_numbers              = var.iam_require_numbers

  # 1.8 – Ensure IAM password policy requires a minimum length of 14 or greater
  minimum_password_length = var.iam_minimum_password_length

  # 1.9 – Ensure IAM password policy prevents password reuse
  password_reuse_prevention = var.iam_password_reuse_prevention

  max_password_age               = var.iam_max_password_age
  allow_users_to_change_password = var.iam_allow_users_to_change_password
  hard_expiry                    = var.iam_hard_expiry
}
