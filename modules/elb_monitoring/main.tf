resource "aws_sns_topic" "elb_notifications" {
  name = "elb-notifications"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = toset(var.subscription_emails)

  topic_arn = aws_sns_topic.elb_notifications.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_cloudwatch_metric_alarm" "elb_latency_alarm" {
  for_each = toset(var.elbs)

  alarm_name          = "latency_alarm_${each.key}"
  alarm_description   = "Alarm for ELB ${each.key} when Latency exceeds the threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Average"
  threshold           = var.latency_threshold
  alarm_actions       = [aws_sns_topic.elb_notifications.arn]

  dimensions = {
    LoadBalancerName = each.key
  }
}
