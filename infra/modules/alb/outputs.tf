output "alb_arn" {
    value = aws_lb.main.arn
}

output "alb_dns_name" {
    value = aws_lb.main.dns_name
}

output "alb_zone_id" {
    value = aws_lb.main.zone_id
}

output "prod_listener_arn" {
    value = aws_lb_listener.l_443.arn
}

output "test_listener_arn" {
    value = aws_lb_listener.l_test.arn
}

output "blue_target_group_arn" {
    value = aws_lb_target_group.blue.arn
}

output "blue_target_group_name" {
    value = aws_lb_target_group.blue.name
}

output "green_target_group_name" {
    value = aws_lb_target_group.green.name
}

output "green_target_group_arn" {
    value = aws_lb_target_group.green.arn
}


