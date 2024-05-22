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
  vpc_id                  = aws_vpc.ec2_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.aws_region
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
  count = length(var.ports)
  name = "security-group-${var.project_name}-${terraform.workspace}-${count.index}"
  description = "Allow inbound traffic to port ${count.index}"
  vpc_id = aws_vpc.ec2_vpc.id

  ingress {
    from_port = count.index
    to_port = count.index
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${var.project_name}-${terraform.workspace}-${count.index}"
    Environment = terraform.workspace
  }
}