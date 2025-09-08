# create vpc

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  region = var.vpc_region

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