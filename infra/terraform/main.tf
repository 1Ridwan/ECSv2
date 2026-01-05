module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  vpc_region         = var.vpc_region
  subnet1_cidr_block = var.subnet1_cidr_block
  subnet2_cidr_block = var.subnet2_cidr_block
  subnet3_cidr_block = var.subnet3_cidr_block
  subnet4_cidr_block = var.subnet4_cidr_block
  az1                = var.az1
  az2                = var.az2
  ecs_service_sg_id  = module.sg.ecs_service_sg_id
  endpoint_sg_id          = module.sg.endpoint_sg_id
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  vpc_region        = var.vpc_region
  alb_sg            = [module.sg.alb_sg_id]
  certificate_arn   = module.acm.certificate_arn
  public_subnet_ids = module.vpc.public_subnet_ids
  container_port    = var.container_port
}

module "sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  container_port = var.container_port
}

module "ecs" {
  source             = "./modules/ecs"
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_service_sg_id  = module.sg.ecs_service_sg_id
  target_group_arn   = module.alb.target_group_arn
  vpc_region         = var.vpc_region
  container_port     = var.container_port

  ecr_repo_url     = module.ecr.ecr_repo_url
  ecr_name         = module.ecr.ecr_repo_name
  ecr_image_digest = module.ecr.ecr_image_digest
}

module "ecr" {
  source = "./modules/ecr"
}

module "acm" {
  source       = "./modules/acm"
  apex_domain  = var.apex_domain
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}