variable "log_group_name" {
  description = "Name of the CloudWatch Log Group that CloudTrail delivers events to."
  type        = string
}

variable "subscription_emails" {
  description = "List of email addresses to subscribe to the SNS topic for alarm notifications."
  type        = list(string)
}

variable "enabled_checks" {
  description = <<EOT
List of CIS control keys to enable. If empty, deploys *all* 14 controls.
Valid keys:
  - unauthorized_api_calls
  - console_signin_without_mfa
  - root_usage
  - iam_policy_changes
  - cloudtrail_cfg_changes
  - console_auth_failures
  - disable_or_schedule_cmk_deletion
  - s3_bucket_policy_changes
  - config_cfg_changes
  - security_group_changes
  - nacl_changes
  - network_gateway_changes
  - route_table_changes
  - vpc_changes
EOT
  type    = list(string)
  default = []
}
