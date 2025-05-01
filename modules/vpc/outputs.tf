output "vpc_id" {
  description = "The ID of the newly created SOC2 VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs for high availability across AZs."
  value       = [for natgw in aws_nat_gateway.this : natgw.id]
}