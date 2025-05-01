
resource "aws_sns_topic" "cpu_notifications" {
  name              = "cpu-notifications"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = toset(var.subscription_emails)

  topic_arn = aws_sns_topic.cpu_notifications.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  for_each = toset(var.instances)

  alarm_name          = "cpu_utilization_alarm_${each.key}"
  alarm_description   = "Alarm for EC2 Instance ${each.key} when CPU utilization exceeds the threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_actions       = [aws_sns_topic.cpu_notifications.arn]

  dimensions = {
    InstanceId = each.key
  }
}