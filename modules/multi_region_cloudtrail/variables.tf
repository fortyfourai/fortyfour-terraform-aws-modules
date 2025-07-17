
variable "logs_bucket_name" {
  description = "Name of the S3 bucket that stores CloudTrail logs. Must already exist."
  type        = string
}

variable "logs_bucket_arn" {
  description = "ARN of the S3 bucket that stores CloudTrail logs."
  type        = string
}

variable "logs_bucket_kms_key_arn" {
  description = "(Optional) KMS key ARN for SSE-KMS encryption of CloudTrail logs. Leave empty for default SSE-S3."
  type        = string
  default     = ""
}

variable "cloudwatch_log_retention_days" {
  description = "Retention (in days) for the CloudWatch Logs group that receives CloudTrail events."
  type        = number
  default     = 90
}

variable "trail_name" {
  description = "CloudTrail name (will also be used in CloudWatch log group name)."
  type        = string
  default     = "multi-region-trail"
}