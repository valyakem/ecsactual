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
  default                   = "10.0.2.0/24" 
}

variable "arcablanca_private_subnet_3_cidr" {
  description               = "Arca-Blanca private subnet 3 cidr"
  default                   = "10.0.2.0/24" 
}

