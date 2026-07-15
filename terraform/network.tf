########################################
# VPC
########################################

resource "aws_vpc" "main" {

  cidr_block           = "10.0.0.0/16"

  enable_dns_hostnames = true

  enable_dns_support   = true

  tags = {

    Name = "${var.project_name}-vpc"

    Environment = var.environment

  }

}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {

    Name = "${var.project_name}-igw"

  }

}

########################################
# Public Subnet 1
########################################

resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {

    Name = "public-subnet-1"

  }

}

########################################
# Public Subnet 2
########################################

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-south-1b"

  map_public_ip_on_launch = true

}

########################################
# Private Subnet 1
########################################

resource "aws_subnet" "private_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.10.0/24"

  availability_zone = "ap-south-1a"

}

########################################
# Private Subnet 2
########################################

resource "aws_subnet" "private_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.20.0/24"

  availability_zone = "ap-south-1b"

}

########################################
# Elastic IP
########################################

resource "aws_eip" "nat" {

  domain = "vpc"

}

########################################
# NAT Gateway
########################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  depends_on = [

    aws_internet_gateway.igw

  ]

}

########################################
# Public Route Table
########################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

}

########################################
# Private Route Table
########################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

}

########################################
# Public Route Association
########################################

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public_1.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public_2.id

  route_table_id = aws_route_table.public.id

}

########################################
# Private Route Association
########################################

resource "aws_route_table_association" "private1" {

  subnet_id = aws_subnet.private_1.id

  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private2" {

  subnet_id = aws_subnet.private_2.id

  route_table_id = aws_route_table.private.id

}
