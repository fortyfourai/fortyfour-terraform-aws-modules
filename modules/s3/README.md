<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.ownership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Block new public ACLs and uploading public objects if true. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Block new public bucket policies if true. | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name for the S3 bucket to create and manage. Must be globally unique. | `string` | n/a | yes |
| <a name="input_custom_policy_json"></a> [custom\_policy\_json](#input\_custom\_policy\_json) | Optional: A custom IAM policy JSON document string to attach to the bucket. If not provided, NO bucket policy is applied by this module. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Ignore public ACLs on this bucket and objects if true. | `bool` | `true` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | ARN of the KMS key to use for encryption, if sse\_algorithm is 'aws:kms'. | `string` | `null` | no |
| <a name="input_log_bucket_name"></a> [log\_bucket\_name](#input\_log\_bucket\_name) | The name of the *target* S3 bucket where server access logs will be delivered. This bucket must already exist and cannot be the same as 'bucket\_name'. | `string` | n/a | yes |
| <a name="input_log_prefix"></a> [log\_prefix](#input\_log\_prefix) | A prefix for log object keys. E.g., 'logs/' or 'access-logs/'. If omitted, logs are delivered to the root of the log\_bucket\_name. | `string` | n/a | yes |
| <a name="input_ownership_controls_rule"></a> [ownership\_controls\_rule](#input\_ownership\_controls\_rule) | Specifies the S3 Object Ownership control rule. 'BucketOwnerEnforced' (recommended, disables ACLs) or 'BucketOwnerPreferred'. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Restrict access to this bucket to only AWS services and authorized users within the bucket owner's account if true. | `bool` | `true` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | Server-side encryption algorithm. 'AES256' or 'aws:kms'. | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the S3 bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name (ID) of the S3 bucket. |
<!-- END_TF_DOCS -->