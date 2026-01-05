terraform {
  backend "s3" {
    bucket       = "terraform-state-ridwan-ecs"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}
