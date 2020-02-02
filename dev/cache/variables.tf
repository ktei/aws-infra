variable environment {
  type = string
}

variable vpc_id {
  type = string
}

variable subnets {
  type = list(string)
}

variable vpc_sg_ids {
  type = list(string)
}
