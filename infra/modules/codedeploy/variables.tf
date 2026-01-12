variable "env_name" { type = string }

variable "ecs_cluster_name" {
    type = string
    description = "name of ecs cluster"
}

variable "ecs_service_name" {
    type = string
    description = "name of ecs service"
}

variable "blue_target_group_name" {
    type = string
    description = "target group name for the ALB target group - blue target group"
}

variable "prod_listener_arn" {
    type = string
    description = "https listener arn for ALB target group - blue target group"
}

variable "test_listener_arn" {
    type = string
    description = "test listener arn for green target group"
}

variable "green_target_group_name" {
    type = string
}