
resource "aws_wafv2_web_acl" "regional_web_acl" {
  name        = var.waf_name
  description = var.waf_description
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = replace(var.waf_name, "-", "")
    sampled_requests_enabled   = true
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          vendor_name = rule.value.vendor_name
          name        = rule.value.rule_name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = replace(rule.value.name, "-", "")
        sampled_requests_enabled   = true
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb_associations" {
  for_each = toset(var.alb_arns)

  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.regional_web_acl.arn
}
