variable "repo_name" {
  type    = string
  default = "testecr"
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "build_project" {
  type    = string
  default = "dev-build-repo"
}

variable "uri_repo" {
  type = string
  default ="440153443065.dkr.ecr.us-east-1.amazonaws.com/testecr"
}

variable "tsl_certificate_arn" {
  type = string
  default ="mycertificatearn"
}