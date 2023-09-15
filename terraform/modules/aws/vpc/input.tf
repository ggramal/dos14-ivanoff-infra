variable "name" {
  description = "VPC name"
  type        = string
}
variable "cidr" {
  description = "VPC cidr"
}
variable "internet_gws" {
  description = "Internet gateways for VPC "
  type = map(
    object({ name = string })
  )
}
variable "nat_gws" {
  description = "Nat gateways for VPC "
  type = map(
    object({ name = string
    subnet = string })
  )
}
variable "subnets" {
  description = "subnets for vpc"
  type = map(object({
    name                = string
    cidr                = string
    public_ip_on_launch = optional(bool, false)
    availability_zone   = string
    routes = list(object({
      cidr        = string
      internet_gw = optional(string)
      nat_gw      = optional(string)
    }))
  }))
}
