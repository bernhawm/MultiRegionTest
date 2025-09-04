variable "source_cluster_arn" {
  type = string
}

variable "destination_cluster_arn" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  type = string
}

variable "source_subnet_ids" {
  type = list(string)
  
}

variable "destination_subnet_ids" {
  type = list(string)
  
}
variable "source_security_group_ids" {
  description = "List of security group IDs for the source cluster"
  type        = list(string)
}

variable "destination_security_group_ids" {
  description = "List of security group IDs for the destination cluster"
  type        = list(string)
}