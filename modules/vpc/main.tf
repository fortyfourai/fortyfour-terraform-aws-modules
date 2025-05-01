resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route = []
  
  tags = {
    Name = "${var.vpc_name}-default-rt"
  }
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress = []
  egress  = []

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.vpc_name}-default-sg"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }
}


# NAT Gateways
# We create one NAT Gateway per private subnet for high availability
resource "aws_eip" "nat" {
  count = length(var.private_subnets)

  domain = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.vpc_name}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "this" {
  count = length(var.private_subnets)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id  

  tags = {
    Name = "${var.vpc_name}-nat-gw-${count.index}"
  }
}


# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
# We create one route table per private subnet for separation.
resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count                   = length(var.private_subnets)
  route_table_id          = aws_route_table.private[count.index].id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.this[count.index].id
  depends_on             = [aws_nat_gateway.this]
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# VPC Flow Logs
# It should be enabled.
resource "aws_cloudwatch_log_group" "flow_log" {
  count               = var.create_flow_logs ? 1 : 0
  name                = "/aws/vpc/${var.vpc_name}-flow-logs"
  retention_in_days   = var.log_retention_in_days
}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  count   = var.create_flow_logs ? 1 : 0
  name    = var.create_flow_logs ? "${var.vpc_name}-flow-logs-role" : null
  assume_role_policy = var.create_flow_logs ? data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json : null
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  count  = var.create_flow_logs ? 1 : 0
  name   = var.create_flow_logs ? "${var.vpc_name}-flow-logs-policy" : null
  policy = var.create_flow_logs ? data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json : null
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.flow_log[0].arn}:*"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  count            = var.create_flow_logs ? 1 : 0
  role             = aws_iam_role.vpc_flow_log_cloudwatch[0].name
  policy_arn       = aws_iam_policy.vpc_flow_log_cloudwatch[0].arn
  depends_on       = [aws_iam_policy.vpc_flow_log_cloudwatch]
}

resource "aws_flow_log" "this" {
  count                = var.create_flow_logs ? 1 : 0
  log_destination       = aws_cloudwatch_log_group.flow_log[0].arn
  vpc_id                = aws_vpc.this.id
  traffic_type          = "ALL"
  iam_role_arn          = aws_iam_role.vpc_flow_log_cloudwatch[0].arn
  depends_on            = [aws_iam_role_policy_attachment.vpc_flow_log_cloudwatch]
}

# Network ACL - Public
# Deny inbound SSH(22), FTP(20,21), RDP(3389) unless block_ssh_ftp_rdp_in_nacl is false
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-public-nacl"
  }
}

resource "aws_network_acl_rule" "public_inbound_deny_ssh" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "public_inbound_deny_ftp20" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.public.id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 20
  to_port        = 20
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "public_inbound_deny_ftp21" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.public.id
  rule_number    = 102
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 21
  to_port        = 21
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "public_inbound_deny_rdp" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.public.id
  rule_number    = 103
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 3389
  to_port        = 3389
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "public_inbound_allow_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "public_outbound_allow_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
  rule_action    = "allow"
}


resource "aws_network_acl_association" "public" {
  count             = length(var.public_subnets)
  subnet_id         = aws_subnet.public[count.index].id
  network_acl_id    = aws_network_acl.public.id
}

# Network ACL - Private
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-private-nacl"
  }
}

# Associate private NACL with private subnets
resource "aws_network_acl_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  network_acl_id = aws_network_acl.private.id
}

resource "aws_network_acl_rule" "private_inbound_deny_ssh" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "private_inbound_deny_ftp20" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.private.id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 20
  to_port        = 20
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "private_inbound_deny_ftp21" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.private.id
  rule_number    = 102
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 21
  to_port        = 21
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "private_inbound_deny_rdp" {
  count        = var.block_ssh_ftp_rdp_in_nacl ? 1 : 0
  network_acl_id = aws_network_acl.private.id
  rule_number    = 103
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 3389
  to_port        = 3389
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "private_inbound_allow_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "private_outbound_allow_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
  rule_action    = "allow"
}

