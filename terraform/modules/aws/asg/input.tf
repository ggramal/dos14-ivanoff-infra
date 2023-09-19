variable "asg_services"{
  type = map(object(
    {
      lt = object({
        name = string
        path = string
      })
      asg = object({
        name = string
        availability_zones = list(string)
        desired_capacity = number
        min_size = number
        max_size = number
      })
    }
  ))
}

variable "asg_sg" {
  description = "Security group for asg"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = set(string)
  }))
}

variable "vpc_id" {
  description = "Get vpc id"
}