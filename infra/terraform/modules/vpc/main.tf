# create vpc

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  region = "eu-west-2"

  tags = {
    Name = "main"
  }
}

# create public subnets

resource "aws_subnet" "public-az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "public-az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "public"
  }
}

# create private subnets

resource "aws_subnet" "private-az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public-az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private"
  }
}