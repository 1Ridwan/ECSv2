variable "vpc_cidr_block" { type = string }
variable "vpc_region" { type = string }
variable "env_name" { type = string }
variable "cpu_size" { type = string }
variable "memory_size" { type = string }
variable "table_name" { type = string }

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

variable "task_count" {
  type        = number
  description = "number of tasks"
  default     = 1
}

variable "test_traffic_port" {
  type        = number
  description = "test traffic port"
}

variable "ecr_repo_name" {
  type        = string
  description = "name of the ecr repo with app's container image"
}

variable "number_of_azs" {
  type        = number
  description = "number of azs to use"
  default     = 2
}

