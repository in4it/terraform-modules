resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.transfer_server_role.arn

  tags = merge(
    {
      NAME = var.transfer_server_name
    },
    var.tags
  )
}

resource "aws_transfer_user" "transfer_server_user" {
  for_each = var.transfer_server_users

  server_id      = aws_transfer_server.transfer_server.id
  user_name      = each.value.name
  role           = aws_iam_role.transfer_server_role.arn
  home_directory = "/${each.value.homedir}"
}

resource "aws_transfer_ssh_key" "transfer_server_ssh_key" {
  for_each = var.transfer_server_users

  server_id = aws_transfer_server.transfer_server.id
  user_name = each.value.name
  body      = each.value.key
}