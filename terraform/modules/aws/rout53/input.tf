variable "domain_name" {
  description = "The domain name for Route53"
  type        = string
  default     = "ivanoff.smodata.net"
}

variable "records" {
  description = "A list of DNS records for Route53"
  type        = list(string)
}

variable "record_type" {
  description = "Type of DNS"
  type        = string
  default     = "A"
}



