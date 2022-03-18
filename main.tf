# provider "aws" {
#   access_key = var.aws-access-key
#   secret_key = var.aws-secret-key
#   region     = var.aws-region
#   version    = "~> 2.0"
# }

# terraform {
#   backend "s3" {
#     bucket  = "terraform-backend-store"
#     encrypt = true
#     key     = "terraform.tfstate"
#     region  = "eu-central-1"
#     # dynamodb_table = "terraform-state-lock-dynamo" - uncomment this line once the terraform-state-lock-dynamo has been terraformed
#   }
# }

# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name           = "terraform-state-lock-dynamo"
#   hash_key       = "LockID"
#   read_capacity  = 20
#   write_capacity = 20
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   tags = {
#     Name = "DynamoDB Terraform State Lock Table"
#   }
# }
module "account" {
  source                      = "./modules/account"
  name                        = var.accountname
  email                       = var.email
  role_name                   = var.role_name
  iam_user_access_to_billing  = var.iam_user_access_to_billing
  parent_id = var.parent_id
}
module "vpc" {
  source             = "./modules/vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}


module "security_groups" {
  source = "./modules/sec-group"
  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.id

  ingress_cidr_blocks      = [module.vpc.cidr]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = module.vpc.cidr
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "alb" {
  source              = "./modules/alb"
  name                = var.name
  vpc_id              = module.vpc.cidr
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}

# module "ecr" {
#   source      = "./modules/ecr"
#   name        = var.name
#   environment = var.environment
# }


# module "secrets" {
#   source              = "./secrets"
#   name                = var.name
#   environment         = var.environment
#   application-secrets = var.application-secrets
# }

# module "ecs" {
#   source                      = "./modules/ecs"
#   name                        = var.name
#   environment                 = var.environment
#   region                      = var.aws-region
#   subnets                     = module.vpc.private_subnets
#   aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
#   ecs_service_security_groups = [module.security_groups.ecs_tasks]
#   container_port              = var.container_port
#   container_cpu               = var.container_cpu
#   container_memory            = var.container_memory
#   service_desired_count       = var.service_desired_count
#   container_environment = [
#     { name = "LOG_LEVEL",
#     value = "DEBUG" },
#     { name = "PORT",
#     value = var.container_port }
#   ]
#   # container_secrets      = module.secrets.secrets_map
#   aws_ecr_repository_url = module.uri_repo
#   # container_secrets_arns = module.secrets.application_secrets_arn
# }

