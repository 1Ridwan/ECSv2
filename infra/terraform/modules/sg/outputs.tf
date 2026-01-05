output "alb_sg_id" {
    value = aws_security_group.allow_https_and_http.id
}

output "ecs_service_sg_id" {
    value = aws_security_group.allow_container_port_traffic_from_alb.id
}

output "endpoint_sg_id" {
    value = aws_security_group.endpoint_security_group.id
}