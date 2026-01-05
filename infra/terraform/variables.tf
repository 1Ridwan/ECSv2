variable "vpc_cidr_block" { type = string }
variable "vpc_region" { type = string }
variable "subnet1_cidr_block" { type = string }
variable "subnet2_cidr_block" { type = string }
variable "subnet3_cidr_block" { type = string }
variable "subnet4_cidr_block" { type = string }
variable "az1" { type = string }
variable "az2" { type = string }

variable "apex_domain" {
  type        = string
  default     = "ridwanprojects.com"
  description = "Hosted zone name for my apex domain"
}

variable "container_port" {
  type        = number
  description = "the port for my app container"
  default     = 8080
}