# vpc module outputs

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "a list of subnet ids that belond to the public subnets in my vpc"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "a list of subnet ids that belond to the private subnets in my vpc"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "the id of the vpc"
}

# alb module outputs

output "target_group_arn" {
  value       = module.alb.target_group_arn
  description = "arn of alb target group that is used by ecs module"
}

# alb outputs for route53 use

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "alb dns name to be used by route53 module"
}

output "alb_zone_id" {
  value       = module.alb.alb_zone_id
  description = "alb zone id to be used by route53 module"

}

# sg module outputs

output "alb_sg" {
  value       = module.sg.alb_sg_id
  description = "alb security group to be used by alb module"
}

output "ecs_service_sg_id" {
  value       = module.ecs_service_sg_id
  description = "ecs service security group"
}

# ecs module outputs

output "ecs_service_sg_id" {
  value = module.sg.ecs_service_sg_id
}

# ecr module outputs

output "ecr_arn" {
  value = module.ecr.ecr_arn
}

output "ecr_repo_url" {
  value = module.ecr.ecr_repo_url
}

output "ecr_image_digest" {
  value = module.ecr.ecr_image_digest
}

output "ecr_repo_name" {
  value = module.ecr.ecr_repo_name
}

# acm outputs

output "certificate_arn" {
  value = module.acm.certificate_arn
}


# output "certificate_dvos" {
#     value = [module.acm.certificate_dvos]
# }
