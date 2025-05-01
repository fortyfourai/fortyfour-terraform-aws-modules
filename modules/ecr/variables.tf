variable "repository_names" {
  description = "A list of names for the ECR repositories to create and manage."
  type        = list(string)
}

variable "enable_scan_on_push" {
  description = "Whether to enable image scanning on push. Recommended for security."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are 'AES256' or 'KMS'. If 'KMS' is specified, kms_key_arn must also be set."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Valid values for encryption_type are 'AES256' or 'KMS'."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption. Required if encryption_type is 'KMS'."
  type        = string
  default     = null
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images. Use with caution!"
  type        = bool
  default     = false
}

variable "custom_policy_json" {
  description = "Optional: A custom IAM policy JSON document string to attach to the ECR repository. If not provided, a default non-public policy will be generated and applied."
  type        = string
  default     = null

  validation {
    condition     = var.custom_policy_json == null || can(jsondecode(var.custom_policy_json))
    error_message = "custom_policy_json must be a valid JSON string or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the ECR repositories."
  type        = map(string)
  default     = {}
}