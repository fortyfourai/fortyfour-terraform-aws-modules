variable "bucket_name" {
  description = "Name for the S3 bucket to create and manage. Must be globally unique."
  type        = string
}

variable "log_bucket_name" {
  description = "The name of the *target* S3 bucket where server access logs will be delivered. This bucket must already exist and cannot be the same as 'bucket_name'."
  type        = string
}

variable "log_prefix" {
  description = "A prefix for log object keys. E.g., 'logs/' or 'access-logs/'. If omitted, logs are delivered to the root of the log_bucket_name."
  type        = string
}

variable "ownership_controls_rule" {
  description = "Specifies the S3 Object Ownership control rule. 'BucketOwnerEnforced' (recommended, disables ACLs) or 'BucketOwnerPreferred'."
  type        = string
  default     = "BucketOwnerEnforced" # Disables ACLs by default.

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred"], var.ownership_controls_rule)
    error_message = "Valid values for ownership_controls_rule are 'BucketOwnerEnforced' or 'BucketOwnerPreferred'."
  }
}

variable "block_public_acls" {
  description = "Block new public ACLs and uploading public objects if true."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block new public bucket policies if true."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs on this bucket and objects if true."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict access to this bucket to only AWS services and authorized users within the bucket owner's account if true."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm. 'AES256' or 'aws:kms'."
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "Valid values are 'AES256' or 'aws:kms'."
  }
}

variable "kms_master_key_id" {
  description = "ARN of the KMS key to use for encryption, if sse_algorithm is 'aws:kms'."
  type        = string
  default     = null
}

variable "custom_policy_json" {
  description = "Optional: A custom IAM policy JSON document string to attach to the bucket. If not provided, NO bucket policy is applied by this module."
  type        = string
  default     = null 

  validation {
    condition     = var.custom_policy_json == null || can(jsondecode(var.custom_policy_json))
    error_message = "custom_policy_json must be a valid JSON string or null."
  }
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default     = {}
}
