variable "vpc_name" {
  type        = string
  description = "Name of the VPC."
  default     = "permify-soc2-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the primary VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones where subnets will be created. The length of this list should match public_subnets/private_subnets length."
  default     = ["us-east-1a", "us-east-1b",]
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs."
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs."
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "create_flow_logs" {
  type        = bool
  description = "Enable or disable VPC Flow Logs."
  default     = true
}

variable "log_retention_in_days" {
  type        = number
  description = "Number of days to retain logs in CloudWatch."
  default     = 90
}

variable "block_ssh_ftp_rdp_in_nacl" {
  type        = bool
  description = "Whether to block SSH(22), FTP(20,21), and RDP(3389) inbound on NACL. Can set to false if a client specifically needs these open."
  default     = true
}

