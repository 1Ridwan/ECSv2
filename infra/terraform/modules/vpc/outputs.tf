output "vpc_id" {
    value = aws_vpc.main.id
}

output "igw_id" {
    value = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public-az1.id,
    aws_subnet.public-az2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private-az1.id,
    aws_subnet.private-az2.id
  ]
}

