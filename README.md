# Terraform AWS Compliance Modules

## Overview

This repository contains a collection of reusable Terraform modules designed to help provision AWS resources according to specific compliance and security best practices. These modules aim to simplify the setup of compliant infrastructure components.

## Modules

The following modules are currently available:

* **`./modules/ec2_monitoring`**: Configures CloudWatch alarms (e.g., CPU Utilization) for EC2 instances with SNS notifications.
* **`./modules/elb_monitoring`**: (Assuming this exists based on initial context) Configures monitoring and potentially logging for Elastic Load Balancers.
* **`./modules/guardduty`**: Enables AWS GuardDuty, configures findings export, and sets up SNS notifications.
* **`./modules/s3`**: Creates S3 buckets with enforced compliance settings like versioning, public access block, logging, encryption, and ACL restrictions.
* **`./modules/vpc`**: Creates a Virtual Private Cloud (VPC) with public/private subnets, optional VPC Flow Logs, and optional restrictive Network ACLs.
* **`./modules/waf`**: Creates a WAFv2 Web ACL, allows configuration of managed/custom rules, and associates it with resources like Application Load Balancers.
* **`./modules/ecr_compliance`**: Creates ECR repositories with tag immutability and restricted access policies enabled.

*Note: Please refer to the `README.md` file within each specific module directory for detailed information on its inputs, outputs, and specific configurations.*

## Prerequisites

1.  **Terraform:** Ensure you have Terraform installed (version 1.2 or later recommended, check individual module `versions.tf` for specifics).
2.  **AWS Credentials:** Configure your AWS credentials locally (e.g., via environment variables, shared credential file, or IAM instance profile). The credentials need sufficient permissions to create the resources defined in the modules you intend to use.
3.  **Module Source:** Ensure the module source paths in your Terraform configuration correctly point to the module directories within this repository (or the location where you host these modules, e.g., Git, Terraform Registry).

## How to Use Modules

To use a module from this repository in your own Terraform configuration:

1.  **Declare a `module` block:** In your `.tf` files, define a module block.
2.  **Set the `source`:** Point the `source` argument to the path of the desired module (e.g., `"./modules/vpc"` if running from the root of this repository, or a Git source like `"git::https://your-repo-url.com/terraform-modules.git//modules/vpc?ref=v1.0.0"`).
3.  **Provide Required Variables:** Pass values for the required input variables defined in the module's `variables.tf` file.
4.  **Customize Optional Variables:** Override default variable values as needed for your specific environment.
5.  **Refer to Module READMEs:** Always consult the specific `README.md` inside the module's directory for detailed usage instructions, variable descriptions, and examples.

## Example Usage (`main.tf`)

An example `main.tf` file is provided in the root of this repository to demonstrate how multiple modules can be combined.

**Note:** This example configuration is for demonstration purposes only and is **not** intended as a complete, production-ready deployment. Production environments typically require additional considerations like remote state backends, provider configuration blocks, more complex variable management, and potentially different resource configurations.

```terraform
# Example combining VPC, GuardDuty, and WAF modules
# (Content of your example main.tf goes here)

# --- VPC Module ---
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block  = "10.10.0.0/16"
  azs             = ["us-west-1a", "us-west-1b", "us-west-1c"]
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
  
  create_flow_logs              = true
  log_retention_in_days         = 90
  block_ssh_ftp_rdp_in_nacl     = true
}

# --- GuardDuty Module ---
module "guardduty_monitoring" {
  source = "./modules/guardduty"

  # provider_region is often inferred, but explicitly set if needed
  # provider_region = "us-west-1" 

  subscription_emails = [
    "your-alert-email@example.com" 
  ]

  enable_s3_logs         = true
  # sns_kms_master_key_id = "alias/aws/sns" # Or your custom key ARN
}

# --- WAF Module ---
module "waf" {
  source = "./modules/waf"

  waf_name        = "example-web-acl"
  waf_description = "Example WAF ACL from modules"
  # Replace with your actual ALB ARN(s)
  alb_arns         = ["arn:aws:elasticloadbalancing:us-west-1:111122223333:loadbalancer/app/my-alb/1234567890abcdef"] 

  # Uses default managed rules unless overridden here
  # managed_rules = [ ... ] 
}

