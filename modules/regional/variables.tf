
variable "tags" {
  description = "Default password for RDS DB"
  type        = string
  default     = ""
}


variable "region" {
  description = "Default password for RDS DB"
  type        = string
  default     = ""
}
variable "sg_id" {
  description = "Default password for RDS DB"
  type        = string
  default     = ""
}

variable "shared_bucket_name" {
  description = "Default password for RDS DB"
  type        = string
  default     = ""
}
variable "cidr_block" {
  type = string
}
variable "subnet_cidrs" {
  type = list(string)
}

# variable "kms_arn" {}
