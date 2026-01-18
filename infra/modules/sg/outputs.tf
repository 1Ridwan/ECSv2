output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
}

output "ecs_service_sg_id" {
    value = aws_security_group.ecs_sg.id
}

output "endpoint_sg_id" {
    value = aws_security_group.endpoint_sg.id
}
