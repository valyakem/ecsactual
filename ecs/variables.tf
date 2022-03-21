variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default = "testecs"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "dev"
}

variable "region" {
  description = "the AWS region in which resources are created"
  default = "us-east-1"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "Port of container"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "container_image" {
  description = "Docker image to be launched"
  default     = "440153443065.dkr.ecr.us-east-1.amazonaws.com/testecr:latest"
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"

}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list
}

# variable "container_secrets" {
#   description = "The container secret environmnent variables"
#   type        = list
# }

# variable "container_secrets_arns" {
#   description = "ARN for secrets"
# }
