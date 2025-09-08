module "vpc" {
    source = "./modules/vpc"
    vpc_cidr_block = var.vpc_cidr_block
    vpc_region = var.vpc_region
    subnet1_cidr_block = var.subnet1_cidr_block
    subnet2_cidr_block = var.subnet2_cidr_block
    subnet3_cidr_block = var.subnet3_cidr_block
    subnet4_cidr_block = var.subnet4_cidr_block
    az1 = var.az1
    az2 = var.az2

    
}