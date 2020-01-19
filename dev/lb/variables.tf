variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}
