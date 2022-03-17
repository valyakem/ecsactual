 variable "name" {
  description = "Account name"
  type = string
  default = "pricingtool-Arca-BLANCA"
}

variable "email" {
  description = "Account email address"
  type = string
  default = "valentine.akem@nexgbits.com"
}

variable "role_name" {
  description = "Account role"
  type = string
  default = "AWSControlTowerAdmin"
}

variable "iam_user_access_to_billing" {
  description = "Allow iam billing role to control this account?"
  type = string
  default = "ALLOW"
}

variable "parent_id" {
  description = "Allow iam billing role to control this account?"
  type = string
  default = "r-tjwo"
}