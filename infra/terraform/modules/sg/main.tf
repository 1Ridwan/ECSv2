# security group for alb must allow all incoming http/https traffic

resource "aws_security_group" "allow_https_and_http" {
  name        = "allow_http"
  description = "Allow all incoming HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_https_and_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  description = "Allow all incoming HTTP traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_https_and_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description = "Allow all incoming HTTPS traffic"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_https_and_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outgoing traffic"
}

# security group for ECS service must allow all traffic from alb on port 8080

resource "aws_security_group" "allow_container_port_traffic_from_alb" {
  name        = "allow_traffic_from_alb"
  description = "Allow incoming traffic from ALB"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_container_port_from_alb" {
  security_group_id = aws_security_group.allow_container_port_traffic_from_alb.id
  referenced_security_group_id = aws_security_group.allow_https_and_http.id # alb security group
  from_port         = var.container_port
  ip_protocol       = "tcp"
  to_port           = var.container_port

  description = "Allow all incoming traffic on port 8080"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ecs" {
  security_group_id = aws_security_group.allow_container_port_traffic_from_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description = "Allow all egress so ECS tasks can reach aws services"
}

# endpoint security group

resource "aws_security_group" "endpoint_security_group" {
    name = "endpoint-sg"
    vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.endpoint_security_group.id
  referenced_security_group_id = aws_security_group.allow_container_port_traffic_from_alb.id # ecs service security group
  ip_protocol       = -1
  description = "Allow all incoming traffic"
}

resource "aws_vpc_security_group_egress_rule" "endpoint_allow_all_traffic" {
  security_group_id = aws_security_group.endpoint_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description = "Allow all outgoing traffic"
}