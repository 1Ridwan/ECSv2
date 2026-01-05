# create vpc

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  region = var.vpc_region
  
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Name = "main"
  }
}

# create public subnets

resource "aws_subnet" "public-az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1_cidr_block
  availability_zone = var.az1

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "public-az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet2_cidr_block
  availability_zone = var.az2
  tags = {
    Name = "public"
  }
}

# create private subnets

resource "aws_subnet" "private-az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet3_cidr_block
  availability_zone = var.az1

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "private-az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet4_cidr_block
  availability_zone = var.az2

  tags = {
    Name = "private"
  }
}

# Create internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# public subnet route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# route table associations

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public-az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public-az2.id
  route_table_id = aws_route_table.public.id
}

# private subnet route table

# traffic should be routed to the VPC endpoints?

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = var.nat_gateway_id_one 
  # }
}

# assign route tables to private subnet route table

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private-az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private-az2.id
  route_table_id = aws_route_table.private.id
}

# vpc gateway endpoints

resource "aws_vpc_endpoint" "s3" {
  service_name      = "com.amazonaws.eu-west-2.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.main.id
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint" "ddb" {
  service_name      = "com.amazonaws.eu-west-2.dynamodb"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.main.id
}

resource "aws_vpc_endpoint_route_table_association" "ddb" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.ddb.id
}

# vpc interface endpoints


 locals {
  vpc_endpoints = [
    "com.amazonaws.${var.vpc_region}.ecr.dkr",
    "com.amazonaws.${var.vpc_region}.ecr.api",
    "com.amazonaws.${var.vpc_region}.ecs",
    "com.amazonaws.${var.vpc_region}.ecs-agent",
    "com.amazonaws.${var.vpc_region}.ecs-telemetry",
    "com.amazonaws.${var.vpc_region}.logs",
    # "com.amazonaws.${var.vpc_region}.secretsmanager",
  ]
}

resource "aws_vpc_endpoint" "endpoints" {
  count = length(local.vpc_endpoints)
  vpc_id = aws_vpc.main.id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  service_name = local.vpc_endpoints[count.index]
  security_group_ids = [var.endpoint_sg_id]
  subnet_ids = [aws_subnet.private-az1.id, aws_subnet.private-az2.id]
}