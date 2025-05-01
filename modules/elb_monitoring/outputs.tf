output "sns_topic_arn" {
  description = "ARN of the SNS topic created for ELB notifications"
  value       = aws_sns_topic.elb_notifications.arn
}