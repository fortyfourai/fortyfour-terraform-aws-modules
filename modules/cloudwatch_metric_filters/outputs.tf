output "sns_topic_arn" {
  description = "The ARN of the SNS topic used for CloudWatch alarms."
  value       = aws_sns_topic.alarms.arn
}
