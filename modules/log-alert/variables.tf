variable "log_groups" {
  type        = list(string)
  default     = []
  description = "List of log group names to subscribe to"
}

variable "logs_filter" {
  type        = string
  description = "The filter to scan the logs for"
  default     = "?error ?Error ?ERROR ?Exception ?EXCEPTION ?exception"
}

variable "alert_emails" {
  type        = list(string)
  default     = []
  description = "List of emails to send notification to"
}

variable "alert_phones" {
  type        = list(string)
  default     = []
  description = "List of phones to send notification to"
}

variable "subject_prefix" {
  type        = string
  default     = "CloudWatch Logs Alert"
  description = "Subject of the alert email"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name"
}
