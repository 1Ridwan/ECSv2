variable "env_name" { type = string }

variable "vpc_region" { 
    type = string
    default = "eu-west-2" 
}

variable "vpc_id" { type = string }
variable "alb_sg" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }

variable "certificate_arn" {
    type = string
    description = "arn of the TLS certificate created for my domain"
}

variable "container_port" {
    type = number
    description = "the port for my container task"
}

variable "apex_domain" {
    type = string
}

variable "test_traffic_port" {
    type = number
    description = "test traffic port"
}