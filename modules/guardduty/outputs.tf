output "detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = aws_guardduty_detector.detector.id
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic for GuardDuty notifications"
  value       = aws_sns_topic.guardduty_notifications.arn
}