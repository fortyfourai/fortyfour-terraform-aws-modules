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
| [aws_cloudwatch_log_metric_filter.cis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.cis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.emails](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled_checks"></a> [enabled\_checks](#input\_enabled\_checks) | List of CIS control keys to enable. If empty, deploys *all* 14 controls.<br/>Valid keys:<br/>  - unauthorized\_api\_calls<br/>  - console\_signin\_without\_mfa<br/>  - root\_usage<br/>  - iam\_policy\_changes<br/>  - cloudtrail\_cfg\_changes<br/>  - console\_auth\_failures<br/>  - disable\_or\_schedule\_cmk\_deletion<br/>  - s3\_bucket\_policy\_changes<br/>  - config\_cfg\_changes<br/>  - security\_group\_changes<br/>  - nacl\_changes<br/>  - network\_gateway\_changes<br/>  - route\_table\_changes<br/>  - vpc\_changes | `list(string)` | `[]` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Name of the CloudWatch Log Group that CloudTrail delivers events to. | `string` | n/a | yes |
| <a name="input_subscription_emails"></a> [subscription\_emails](#input\_subscription\_emails) | List of email addresses to subscribe to the SNS topic for alarm notifications. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic used for CloudWatch alarms. |
<!-- END_TF_DOCS -->