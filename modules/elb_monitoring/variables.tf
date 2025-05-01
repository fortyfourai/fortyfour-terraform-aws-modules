variable "elbs" {
  description = "List of ELB IDs to monitor"
  type        = list(string)
}

variable "subscription_emails" {
  description = "List of email addresses to subscribe to SNS notifications"
  type        = list(string)
}

variable "latency_threshold" {
  description = "Threshold for latency alarm in seconds"
  type        = number
  default     = 0.5
}

