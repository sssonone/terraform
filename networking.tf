resource "aws_vpc" "terraform_test_vpc"{

  cidr_block         = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform_test_vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

// Here this IGW resource will be created in the VPC created in this file itself.
resource "aws_internet_gateway" "terraform_test_internet_gateway" {
  vpc_id = aws_vpc.terraform_test_vpc.id

  tags = {
    Name = "terraform_test_internet_gateway"
  }
}
resource "aws_route_table" "terraform_public_rt" {
  vpc_id = aws_vpc.terraform_test_vpc.id

  tags = {
    Name = "terraform_public_rt"
  }
}

resource "aws_route" "terraform_test_route" {
  route_table_id     = aws_route_table.terraform_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_test_internet_gateway.id
}
resource "aws_route_table" "terraform_private_rt" {
  vpc_id = aws_vpc.terraform_test_vpc.id

  tags = {
    Name = "terraform_private_rt"
  }
}
data "aws_availability_zones" "available" {}
resource "random_id" "random" {
  byte_length = 2
}

resource "aws_subnet" "terraform_public_test_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.terraform_test_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "terraform_public_test_subnet"
  }
}

resource "aws_subnet" "terraform_private_test_subnet" {
  count      = 2
  vpc_id     = aws_vpc.terraform_test_vpc.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "terraform_private_test_subnet"
  }
}
resource "aws_route_table_association" "terraform_public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.terraform_public_test_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_public_rt.id
}

resource "aws_route_table_association" "terraform_private_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.terraform_private_test_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_private_rt.id
}
resource "aws_security_group" "terraform_test_sg" {
  name        = "terraform_test_sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.terraform_test_vpc.id
}

resource "aws_security_group_rule" "ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.access_ip]
  security_group_id = aws_security_group.terraform_test_sg.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_test_sg.id
}
resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_test_sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_test_sg.id
}

resource "aws_security_group_rule" "ssh_egress" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.access_ip]
  security_group_id = aws_security_group.terraform_test_sg.id
}