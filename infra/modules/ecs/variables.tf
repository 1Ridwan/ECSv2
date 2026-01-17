variable "env_name" { type = string }

variable "vpc_id" { type = string }

variable "private_subnet_ids" { type = list(string) }

variable "ecr_repo_name" {
      type = string
      description = "name of the ecr repository with app's container image"
  }

variable "ecs_service_sg_id" { type = string }

variable "vpc_region" {
    type = string
    default = "eu-west-2"
}

variable "container_port" {
    type = number
    description = "the port for my container"
}

variable "task_count" {
    type = string
    description = "number of desired tasks"
    default = 1
}

variable "cpu_size" { type = string }

variable "memory_size" { type = string }

variable "table_name" { type = string }

variable "blue_target_group_arn" {
    type = string
    description = "target group name for the ALB target group - blue target group"
}