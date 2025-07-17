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
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.trail_to_cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.trail_to_cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket_policy.trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cw_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trail_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention_days"></a> [cloudwatch\_log\_retention\_days](#input\_cloudwatch\_log\_retention\_days) | Retention (in days) for the CloudWatch Logs group that receives CloudTrail events. | `number` | `90` | no |
| <a name="input_logs_bucket_arn"></a> [logs\_bucket\_arn](#input\_logs\_bucket\_arn) | ARN of the S3 bucket that stores CloudTrail logs. | `string` | n/a | yes |
| <a name="input_logs_bucket_kms_key_arn"></a> [logs\_bucket\_kms\_key\_arn](#input\_logs\_bucket\_kms\_key\_arn) | (Optional) KMS key ARN for SSE-KMS encryption of CloudTrail logs. Leave empty for default SSE-S3. | `string` | `""` | no |
| <a name="input_logs_bucket_name"></a> [logs\_bucket\_name](#input\_logs\_bucket\_name) | Name of the S3 bucket that stores CloudTrail logs. Must already exist. | `string` | n/a | yes |
| <a name="input_trail_name"></a> [trail\_name](#input\_trail\_name) | CloudTrail name (will also be used in CloudWatch log group name). | `string` | `"multi-region-trail"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudtrail_to_cw_role_arn"></a> [cloudtrail\_to\_cw\_role\_arn](#output\_cloudtrail\_to\_cw\_role\_arn) | IAM role ARN that CloudTrail assumes to write to CloudWatch Logs. |
| <a name="output_cloudtrail_trail_arn"></a> [cloudtrail\_trail\_arn](#output\_cloudtrail\_trail\_arn) | ARN of the CloudTrail trail. |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the CloudWatch log group used by CloudTrail. |
<!-- END_TF_DOCS -->