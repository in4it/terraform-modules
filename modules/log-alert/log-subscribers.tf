resource "aws_sns_topic_subscription" "email_alert_subscription" {
  for_each                        = toset(var.alert_emails)
  protocol                        = "email"
  endpoint                        = each.value
  topic_arn                       = aws_sns_topic.alert_topic.arn
  confirmation_timeout_in_minutes = 5

  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "sms_alert_subscription" {
  for_each                        = toset(var.alert_phones)
  protocol                        = "sms"
  endpoint                        = each.value
  topic_arn                       = aws_sns_topic.alert_topic.arn
  confirmation_timeout_in_minutes = 5

  endpoint_auto_confirms = true
}
