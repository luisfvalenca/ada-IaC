resource "aws_vpc" "ec2_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.project_name}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "ec2_subnet" {
  vpc_id = aws_vpc.ec2_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-${var.project_name}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = aws_vpc.ec2_vpc.id
  tags = {
    Name = "igw-${var.project_name}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "ec2_route_table" {
  vpc_id = aws_vpc.ec2_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_igw.id
  }
  tags = {
    Name = "route-table-${var.project_name}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_route_table_association" "ec2_route_table_assoc" {
  subnet_id = aws_subnet.ec2_subnet.id
  route_table_id = aws_route_table.ec2_route_table.id
}

resource "aws_security_group" "ec2_sg" {
  name = "security-group-${var.project_name}-${terraform.workspace}"
  description = "Allow inbound traffic to app ports"
  vpc_id = aws_vpc.ec2_vpc.id
  tags = {
    Name = "security-group-${var.project_name}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "allow_ingress_ports" {
  count = length(var.ports)
  type = "ingress"
  description = "Allow inbound traffic to port ${count.index}"
  from_port = count.index
  to_port = count.index
  protocol = "tcp"
  cidr_blocks = [aws_vpc.ec2_vpc.cidr_block]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "allow_egress" {
  type = "egress"  
  description = "Allow outbound traffic"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [aws_vpc.ec2_vpc.cidr_block]
  security_group_id = aws_security_group.ec2_sg.id
}