# This main file prepared to show how to use the modules with the variables
# It is not intended to be used as a full deployment

module "vpc" {
  source = "./modules/vpc"


  vpc_cidr_block  = "10.10.0.0/16"
  azs             = ["us-west-1a", "us-west-1b", "us-west-1c"]
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
  
  create_flow_logs              = true
  log_retention_in_days         = 90
  
  # Optionally enable/disable NACL blocks. Its going to block ports: 20, 21, 22, 3389 for all subnets
  # Some security controls want nacls to be enabled
  block_ssh_ftp_rdp_in_nacl     = true
}


module "guardduty_monitoring" {
  source = "./modules/guardduty"

  provider_region = "us-west-1"

  subscription_emails = [
    "your-email@example.com",
    "another-email@example.com"
  ]

  enable_s3_logs         = true
  sns_kms_master_key_id = "alias/aws/sns"
}

module "waf" {
  source = "./modules/waf"

  waf_name        = "web-acl"
  waf_description = "Custom WAF ACL"
  alb_arns         = ["arn:aws:elasticloadbalancing:us-west-1:324346964728:loadbalancer/app/k8s-otelgate-infrasta-0ca540b3fe/c023cf5d7e19b44c"]

  # Optional: Override the default managed rules
  managed_rules = [
    {
      name        = "Managed-AWS-AmazonIpReputation"
      priority    = 1
      vendor_name = "AWS"
      rule_name   = "AWSManagedRulesAmazonIpReputationList"
    },
    {
      name        = "Managed-AWS-CommonRuleSet"
      priority    = 2
      vendor_name = "AWS"
      rule_name   = "AWSManagedRulesCommonRuleSet"
    }
  ]
}

