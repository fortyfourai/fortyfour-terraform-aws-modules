variable "enable_s3_logs" {
  description = "Enable S3 logs monitoring in GuardDuty"
  type        = bool
  default     = true
}

variable "subscription_emails" {
  description = "List of email addresses to subscribe to GuardDuty notifications"
  type        = list(string)
}

variable "sns_kms_master_key_id" {
  description = "KMS key ID for SNS topic encryption"
  type        = string
  default     = "alias/aws/sns"
}

variable "provider_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}