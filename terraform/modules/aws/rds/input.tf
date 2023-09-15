variable "name" {
  description = "rds name"
  type        = string
}
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}
variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = null
}
variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}
variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = null
}
variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}
variable "password" {
  description = "Password for the master DB user."
  type        = string
  default     = null
  sensitive   = true
}
variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}
variable "rds-subnet" {
  description = "Subnet for rds"
  type = map(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}
variable "rds-sg" {
  description = "Secret group for rds"
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