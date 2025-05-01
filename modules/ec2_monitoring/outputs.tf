output "sns_topic_arn" {
  description = "ARN of the SNS topic created for CPU notifications"
  value       = aws_sns_topic.cpu_notifications.arn
}