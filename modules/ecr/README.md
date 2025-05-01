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
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.repo_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.default_ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_policy_json"></a> [custom\_policy\_json](#input\_custom\_policy\_json) | Optional: A custom IAM policy JSON document string to attach to the ECR repository. If not provided, a default non-public policy will be generated and applied. | `string` | `null` | no |
| <a name="input_enable_scan_on_push"></a> [enable\_scan\_on\_push](#input\_enable\_scan\_on\_push) | Whether to enable image scanning on push. Recommended for security. | `bool` | `true` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The encryption type to use for the repository. Valid values are 'AES256' or 'KMS'. If 'KMS' is specified, kms\_key\_arn must also be set. | `string` | `"AES256"` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | If true, will delete the repository even if it contains images. Use with caution! | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to use for encryption. Required if encryption\_type is 'KMS'. | `string` | `null` | no |
| <a name="input_repository_names"></a> [repository\_names](#input\_repository\_names) | A list of names for the ECR repositories to create and manage. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the ECR repositories. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_applied_policy_json"></a> [applied\_policy\_json](#output\_applied\_policy\_json) | The actual policy JSON applied to the repositories (custom or default). |
| <a name="output_repository_arns"></a> [repository\_arns](#output\_repository\_arns) | Map of repository names to their corresponding ARNs. |
| <a name="output_repository_ids"></a> [repository\_ids](#output\_repository\_ids) | Map of repository names to their corresponding registry IDs (AWS Account ID). |
| <a name="output_repository_urls"></a> [repository\_urls](#output\_repository\_urls) | Map of repository names to their corresponding repository URLs. |
<!-- END_TF_DOCS -->