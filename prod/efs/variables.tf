variable "environment" {
  type = string
}

variable "subnets" {
  type = set(string)
}

variable "security_groups" {
  type = list(string)
}
