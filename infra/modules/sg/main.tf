# ---------- ALB security group ---------- # 

# security group for alb must allow all incoming http/https traffic

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "SG for application load balancer that allow all incoming HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description = "Allow all incoming HTTP traffic"
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description = "Allow all incoming HTTPS traffic"
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_test_traffic" { 
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.test_traffic_port # allow all incoming traffic on test traffic port for blue/green deployment
  ip_protocol       = "tcp"
  to_port           = var.test_traffic_port
  description = "Allow all incoming traffic on the test traffic port"
}

resource "aws_vpc_security_group_egress_rule" "alb_allow_all__outgoing_traffic" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description = "Allow all outgoing traffic from ALB"
}

# ---------- ECS security group ---------- # 

# security group for ECS service must allow all traffic from alb on the container port

resource "aws_security_group" "ecs_sg" {
  name        = "ECS service security group"
  description = "Allow incoming traffic from ALB"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_container_port_from_alb" {
  security_group_id = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id # alb security group
  from_port         = var.container_port
  ip_protocol       = "tcp"
  to_port           = var.container_port
  description = "Allow all incoming traffic on container port"
}

resource "aws_vpc_security_group_egress_rule" "allow_ecs_to_endpoints" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  description = "Allow all outgoing traffic"
}

# ---------- Endpoint security group ---------- # 

# endpoint security group must allow all traffic from ecs security group

resource "aws_security_group" "endpoint_sg" {
    name = "endpoint-sg"
    vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.endpoint_sg.id
  # referenced_security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  description = "Allow all incoming traffic"
}

resource "aws_vpc_security_group_egress_rule" "endpoint_allow_all_traffic" {
  security_group_id = aws_security_group.endpoint_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  description = "Allow all outgoing traffic"
}