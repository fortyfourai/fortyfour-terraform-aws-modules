
output "cloudtrail_trail_arn" {
  value       = aws_cloudtrail.this.arn
  description = "ARN of the CloudTrail trail."
}

output "cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.trail.name
  description = "Name of the CloudWatch log group used by CloudTrail."
}

output "cloudtrail_to_cw_role_arn" {
  value       = aws_iam_role.trail_to_cw.arn
  description = "IAM role ARN that CloudTrail assumes to write to CloudWatch Logs."
}
