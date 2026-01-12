variable "vpc_id" { type = string }

variable "container_port" {
    type = number
    description = "the port for the app container"
}

variable "test_traffic_port" {
    type = number
    description = "test traffic port for codedeploy blue-green deployment"
    default = 8443
}