variable "instances" {
  description = "List of EC2 Instance IDs to monitor"
  type        = list(string)
}

variable "subscription_emails" {
  description = "List of email addresses to subscribe to SNS notifications"
  type        = list(string)
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization alarm (percentage)"
  type        = number
  default     = 80
}