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
| [aws_cloudwatch_event_rule.guardduty_finding_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.guardduty_finding_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_guardduty_detector.detector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_sns_topic.guardduty_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.guardduty_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.email_subscriptions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_s3_logs"></a> [enable\_s3\_logs](#input\_enable\_s3\_logs) | Enable S3 logs monitoring in GuardDuty | `bool` | `true` | no |
| <a name="input_provider_region"></a> [provider\_region](#input\_provider\_region) | AWS region | `string` | `"us-west-1"` | no |
| <a name="input_sns_kms_master_key_id"></a> [sns\_kms\_master\_key\_id](#input\_sns\_kms\_master\_key\_id) | KMS key ID for SNS topic encryption | `string` | `"alias/aws/sns"` | no |
| <a name="input_subscription_emails"></a> [subscription\_emails](#input\_subscription\_emails) | List of email addresses to subscribe to GuardDuty notifications | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_detector_id"></a> [detector\_id](#output\_detector\_id) | The ID of the GuardDuty detector |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic for GuardDuty notifications |
<!-- END_TF_DOCS -->