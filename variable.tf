variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_availability_zones" {
  default = {
    ap-northeast-1 = "ap-northeast-1a,ap-northeast-1c,ap-northeast-1d"
  }
}

variable "network_address_space" {
  default = "10.0.0.0/16"
}

variable "subnet1_address_space" {
  default = "10.0.0.0/24"
}

variable "subnet2_address_space" {
  default = "10.0.1.0/24"
}

variable "subnet3_address_space" {
  default = "10.0.2.0/24"
}

variable "subnet4_address_space" {
  default = "10.0.3.0/24"
}

variable "public_subnet_count" {
  default = "2"
}

variable "private_subnet_count" {
  default = "2"
}

variable "public_vm_instance_count" {
  default = "3"
}

variable "private_vm_instance_count" {
  default = "4"
}
