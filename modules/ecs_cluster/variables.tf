#------------------------------------------------------------------------------
# ECS CLUSTER
#------------------------------------------------------------------------------
variable "name" {
  description = "The name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  default     = "arca-lanca-pt"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}
