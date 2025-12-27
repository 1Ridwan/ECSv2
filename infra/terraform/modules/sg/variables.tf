variable "vpc_id" { type = string }
variable "vpc_cidr_block" { type = string }

variable "container_port" {
    type = number
    description = "the port for my container"
}