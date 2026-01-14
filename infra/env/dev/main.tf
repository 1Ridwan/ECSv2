module "vpc" {
  source            = "../../modules/vpc"
  vpc_cidr_block    = var.vpc_cidr_block
  vpc_region        = var.vpc_region
  ecs_service_sg_id = module.sg.ecs_service_sg_id
  endpoint_sg_id    = module.sg.endpoint_sg_id
  env_name          = var.env_name
  number_of_azs     = var.number_of_azs
}

module "ecs" {
  source                = "../../modules/ecs"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_service_sg_id     = module.sg.ecs_service_sg_id
  container_port        = var.container_port
  ecr_repo_name         = var.ecr_repo_name
  task_count            = var.task_count
  env_name              = var.env_name
  table_name            = var.table_name
  cpu_size              = var.cpu_size
  memory_size           = var.memory_size
  blue_target_group_arn = module.alb.blue_target_group_arn
}

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.vpc.vpc_id
  alb_sg            = [module.sg.alb_sg_id]
  certificate_arn   = module.acm.certificate_arn
  public_subnet_ids = module.vpc.public_subnet_ids
  container_port    = var.container_port
  test_traffic_port = var.test_traffic_port
  apex_domain       = var.apex_domain
  env_name          = var.env_name
}

module "sg" {
  source         = "../../modules/sg"
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

module "acm" {
  source       = "../../modules/acm"
  apex_domain  = var.apex_domain
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
  env_name     = var.env_name
}

module "ddb" {
  source   = "../../modules/ddb"
  env_name = var.env_name
}

# -------- Codedeploy module omitted from dev environment -------- #