
variable "target_group_arn" { type = string }

variable "private_subnet_ids" { type = list(string) }

variable "ecs_service_sg_id" { type = string }

variable "ecr_repo_url" {
    type = string
    description = "the url of the ecr repository holding the container images"
}

variable "ecr_name" { type = string }

variable "ecr_image_digest" { type = string }

variable "vpc_region" { type = string }

variable "container_port" {
    type = number
    description = "the port for my container"
}