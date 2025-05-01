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
| [aws_cloudwatch_metric_alarm.elb_latency_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.elb_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email_subscriptions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elbs"></a> [elbs](#input\_elbs) | List of ELB IDs to monitor | `list(string)` | n/a | yes |
| <a name="input_latency_threshold"></a> [latency\_threshold](#input\_latency\_threshold) | Threshold for latency alarm in seconds | `number` | `0.5` | no |
| <a name="input_subscription_emails"></a> [subscription\_emails](#input\_subscription\_emails) | List of email addresses to subscribe to SNS notifications | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic created for ELB notifications |
<!-- END_TF_DOCS -->