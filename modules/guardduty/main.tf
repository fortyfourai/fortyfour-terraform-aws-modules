provider "aws" {
  region = var.provider_region
}

resource "aws_guardduty_detector" "detector" {
  enable   = true

  datasources {
    s3_logs {
      enable = var.enable_s3_logs
    }
  }
}

resource "aws_sns_topic" "guardduty_notifications" {
  name              = "guardduty-notifications"
  kms_master_key_id = var.sns_kms_master_key_id
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = toset(var.subscription_emails)

  topic_arn = aws_sns_topic.guardduty_notifications.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_cloudwatch_event_rule" "guardduty_finding_rule" {
  name        = "guardduty-finding-rule"
  description = "Captures GuardDuty Finding events"
  event_pattern = jsonencode({
    "source":      ["aws.guardduty"],
    "detail-type": ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "guardduty_finding_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_finding_rule.name
  target_id = "SNSGuardDuty"
  arn       = aws_sns_topic.guardduty_notifications.arn
}

resource "aws_sns_topic_policy" "guardduty_topic_policy" {
  arn    = aws_sns_topic.guardduty_notifications.arn
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid":       "Allow_EventBridge_To_Publish",
        "Effect":    "Allow",
        "Principal": { "Service": "events.amazonaws.com" },
        "Action":    "SNS:Publish",
        "Resource":  aws_sns_topic.guardduty_notifications.arn
      }
    ]
  })
}
