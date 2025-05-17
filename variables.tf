variable "cidr_block_use2"{
  default = "10.0.0.0/16"
  type = string
}

variable "cidr_block_use1" {
    default = "10.1.0.0/16"
  type = string
}

variable "subnet_cidrs_use2" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "subnet_cidrs_use1" {
  type = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}