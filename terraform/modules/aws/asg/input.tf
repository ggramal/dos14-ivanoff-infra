variable "asg_services"{
  type = map(object(
    {
      lt = object({
        name = string
        path = string
        instance_type = string
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

variable "secret_authz" {
  description = "Secret authz"
  type = string
}

variable "git_branches" {
  description = "Git branches to services"
  type = object(
    {
    authn = string
    authz = string
    bank = string
  }
  )
}