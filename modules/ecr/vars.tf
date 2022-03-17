variable "name" {
  description = "the name of your stack, e.g. \"demo\""
   default = "pricing-tool"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
   default     = "prod"
}

variable "uri_repo" {
  type = string
  default ="440153443065.dkr.ecr.us-east-1.amazonaws.com/testecr"
}