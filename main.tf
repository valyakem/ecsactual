# module "vpc" {
#   source             = "./modules/vpc"
#   name               = var.name
#   cidr               = var.cidr
#   private_subnets    = var.private_subnets
#   public_subnets     = var.public_subnets
#   availability_zones = var.availability_zones
#   environment        = var.environment
# }