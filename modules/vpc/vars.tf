variable "cidr" {
  type    = string
  default = "145.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "subnets-ip" {
  type = list(string)
  default = [
    "145.0.1.0/24",
    "145.0.2.0/24"
  ]

}

variable "vpc_id" {
  type    = string
  default = "145.0.0.0/16"
}

variable "ecs_name" {
  type    = string
  default = "ecs_vpc"
}