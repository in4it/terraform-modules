resource "aws_dynamodb_table" "terraform-state-lock" {
  count          = var.lock_table_enabled ? 1 : 0
  name           = "terraform-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "${var.project}-${var.env}-terraform-state-lock"
    Project     = var.project
    Environment = var.env
  }
}
