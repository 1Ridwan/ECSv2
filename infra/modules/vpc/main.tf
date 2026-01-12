# create vpc

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  region = var.vpc_region
  
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Name = "${var.env_name}-vpc"
  }
}

# get available AZs

data "aws_availability_zones" "available" {
  state = "available"
  region = "eu-west-2"
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

locals {
  az_count = length(data.aws_availability_zones.available.names)
}

# create public and private subnets

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  count = var.number_of_azs
  cidr_block = cidrsubnet(var.vpc_cidr_block, 7, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${data.aws_availability_zones.available.names[count.index]}-${var.env_name}"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  count = var.number_of_azs
  cidr_block = cidrsubnet(var.vpc_cidr_block, 7, var.number_of_azs + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${data.aws_availability_zones.available.names[count.index]}-${var.env_name}"
  }
}

# Create internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# public subnet route table and association

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count = var.number_of_azs
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# private subnet route table and association

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  count = var.number_of_azs
  subnet_id = aws_subnet.private[count.index].id
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
  subnet_ids = aws_subnet.private.*.id
}