variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "azs" {
  default = [
    "sa-east-1a",
    "sa-east-1b"
  ]
}

variable "cluster_name" {
    default = "miura-cluster"
}