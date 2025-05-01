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
| [aws_wafv2_web_acl.regional_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arns"></a> [alb\_arns](#input\_alb\_arns) | List of Application Load Balancer ARNs to associate with WAF | `list(string)` | n/a | yes |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | List of AWS managed rules to include | <pre>list(object({<br/>    name        = string<br/>    priority    = number<br/>    vendor_name = string<br/>    rule_name   = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "Managed-AWS-AmazonIpReputation",<br/>    "priority": 1,<br/>    "rule_name": "AWSManagedRulesAmazonIpReputationList",<br/>    "vendor_name": "AWS"<br/>  },<br/>  {<br/>    "name": "Managed-AWS-AnonymousIpList",<br/>    "priority": 2,<br/>    "rule_name": "AWSManagedRulesAnonymousIpList",<br/>    "vendor_name": "AWS"<br/>  },<br/>  {<br/>    "name": "Managed-AWS-CommonRuleSet",<br/>    "priority": 3,<br/>    "rule_name": "AWSManagedRulesCommonRuleSet",<br/>    "vendor_name": "AWS"<br/>  }<br/>]</pre> | no |
| <a name="input_waf_description"></a> [waf\_description](#input\_waf\_description) | Description of the WAF ACL | `string` | `"WAF ACL for ALB"` | no |
| <a name="input_waf_name"></a> [waf\_name](#input\_waf\_name) | Name of the WAF ACL | `string` | `"regional-web-acl"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | ARN of the WAF Web ACL |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | ID of the WAF Web ACL |
<!-- END_TF_DOCS -->