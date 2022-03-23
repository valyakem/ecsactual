module "vpc" {
  source             = "./modules/vpc"
  name               = var.name
  cidr               = var.cidr
  pub_subnet1        = var.private_subnets1
  pub_subnet2        = var.private_subnets2
  pub_subnet3        = var.private_subnets3
  private_subnet1    = var.private_subnets1
  private_subnet2    = var.private_subnets2
  private_subnet3    = var.private_subnets3
  //availability_zones = var.availability_zones
}