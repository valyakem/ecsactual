variable "name" {
  description = "VPC name"
  default = "pricing-tool"
}

variable "environment" {
  description = "environment"
  default = "prod"
}

variable "sg1" {
  description = "security group one name"
  default = "flask-server"
}