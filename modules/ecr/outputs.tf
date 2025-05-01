output "repository_arns" {
  description = "Map of repository names to their corresponding ARNs."
  value       = { for name, repo in aws_ecr_repository.repo : name => repo.arn }
}

output "repository_urls" {
  description = "Map of repository names to their corresponding repository URLs."
  value       = { for name, repo in aws_ecr_repository.repo : name => repo.repository_url }
}

output "repository_ids" {
  description = "Map of repository names to their corresponding registry IDs (AWS Account ID)."
  value       = { for name, repo in aws_ecr_repository.repo : name => repo.registry_id }
}

output "applied_policy_json" {
  description = "The actual policy JSON applied to the repositories (custom or default)."
  value       = local.effective_policy_json
  sensitive   = true # Policy might contain sensitive info like account IDs
}