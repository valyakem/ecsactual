
#=====================================================================================
#     VPC (vpc.tf) VARIABLES. Note: Arca Blanca pricing Tool
#======================================================================================
variable "vpc_cidr" {
    default                 = "10.0.0.0/16"
    description             = "Pricing Tool cidr block"
}

variable "enable_dns_hostnames" {
  description               = "Enable dnshostname or not? Boolean field"
  default                   = true 
}           

variable "arcablanca_pub_subnet_1_cidr" {
  description               = "Arca-Blanca public subnet 1 cidr"
  default                   = "10.0.1.0/24" 
}

variable "arcablanca_pub_subnet_2_cidr" {
  description               = "Arca-Blanca public subnet 2 cidr"
  default                   = "10.0.2.0/24" 
}

variable "arcablanca_pub_subnet_3_cidr" {
  description               = "Arca-Blanca public subnet 3 cidr"
  default                   = "10.0.3.0/24"
}


variable "arcablanca_private_subnet_1_cidr" {
  description               = "Arca-Blanca private subnet 1 cidr"
  default                   = "10.0.4.0/24" 
}


variable "arcablanca_private_subnet_2_cidr" {
  description               = "Arca-Blanca private subnet 2 cidr"
  default                   = "10.0.5.0/24" 
}

variable "arcablanca_private_subnet_3_cidr" {
  description               = "Arca-Blanca private subnet 3 cidr"
  default                   = "10.0.2.0/24" 
}

variable "public_subnetslist" {
  description                 = "List of private subnet for output purposes only"
  type                        = list(string)
  default                     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "Arcablanca-PubRT" {
  description                 = "Route tables tagging"
  default                     = "Arca-Blanca" 
}

variable "Arcablanca-PrivRT" {
  description                 = "Route tables tagging"
  default                     = "Arca-Blanca" 
}

variable "Arcablanca-PrivRT-Assoc" {
  description                 = "Route tables association tagging"
  default                     = "Arca-Blanca-PrivRT-Assoc" 
}

variable "Arcablanca-PubRT-Assoc" {
  description                 = "Route tables association tagging"
  default                     = "Arca-Blanca-PubRT-Assoc" 
}
#=====================================================================================
#     ECS (ecs.tf) VARIABLES. Note:Arca Blanca pricing Tool
#======================================================================================
variable "arca-blanca-clustername" {
  description                 = "Arca blanca ECS Cluster name"
  default                     = "arca-blancapt-cluster"
}

variable "arcblanca_internet_cidr" {
  description                 = "Internet Cidr block for load balancer ingress"
  default                     = "0.0.0.0/0" 
}   

variable "ecs_arcablanca_domain" {
  description                 = "ECS Arca blanca domain name"
  default                     = "nexgbits.academy" 
}

variable "internet_cidr_blocks" {
  description                 = "Classless interdomain routing (cidr) block for internet"
  default                     = "0.0.0.0/0"
}

variable "private_subnetslist" {
  description                 = "List of private subnet for output purposes only"
  type                        = list(string)
  default                     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}


#=====================================================================================
#     Application (app.tf) VARIABLES. Note: abpt=> Arca Blanca pricing Tool
#======================================================================================
variable "abpt_ecs_service_name" {
  description           = "ECS service name"
  default               = "arcablancaapp" 
}
variable "docker_image_url" {
  description           = "Docker Image URI locator"
  default               = "440153443065.dkr.ecr.us-east-1.amazonaws.com/testecr" 
}

variable "arcablanca_pt_profile" {
  description           = "ARCA BLANCA PROFILE NAME"
  default               = "default" 
}

variable "task_definition_name" {
  description           = "task definition name"
  default               = "abpt-task-def" 
}
variable "abpt_docker_memory" {
  description           = "Memory in GB assigned to the docker container"
  default               = 1024 
}
variable "abpt_docker_container_port" {
  description           = "port assigned to the container"
  default               = 8080 
} 

#ECS Service Variables
#----------------------------------
variable "desired_count_number" {
  description            = "Arca BLANCA ECS service count. Should be number"
  default                = 1
}

variable "desired_task_number" {
  description            = "Min. Number of tasks to be always active. Should be number"
  default                = 2
}

variable "arca-blanca-fargate-cluster" {
  description             = "Arca-Blanca Fargate Cluster description"
  default                 = "Arca-blanca-fargate-cluster"
}

variable "region" {
  description = "Container's region"
  default = "us-east-1"
}

variable "abpt_docker_host_port" {
  description = "Container host's port"
  default = "80"
}
