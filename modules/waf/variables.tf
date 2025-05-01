variable "waf_name" {
  description = "Name of the WAF ACL"
  type        = string
  default     = "regional-web-acl"
}

variable "waf_description" {
  description = "Description of the WAF ACL"
  type        = string
  default     = "WAF ACL for ALB"
}

variable "managed_rules" {
  description = "List of AWS managed rules to include"
  type = list(object({
    name        = string
    priority    = number
    vendor_name = string
    rule_name   = string
  }))
  default = [
    {
      name        = "Managed-AWS-AmazonIpReputation"
      priority    = 1
      vendor_name = "AWS"
      rule_name   = "AWSManagedRulesAmazonIpReputationList"
    },
    {
      name        = "Managed-AWS-AnonymousIpList"
      priority    = 2
      vendor_name = "AWS"
      rule_name   = "AWSManagedRulesAnonymousIpList"
    },
    {
      name        = "Managed-AWS-CommonRuleSet"
      priority    = 3
      vendor_name = "AWS"
      rule_name   = "AWSManagedRulesCommonRuleSet"
    }
  ]
}

variable "alb_arns" {
  description = "List of Application Load Balancer ARNs to associate with WAF"
  type        = list(string)
}