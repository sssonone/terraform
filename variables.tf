variable "vpc_cidr" {
  type    = string
  description = "Enter the VPC CIDR Value."
  // default = "10.0.0.0/16"
}

variable "vpc_tag_name" {
  type    = string
  description = "Enter the VPC Tag Value"
}

variable "public_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "public_cidrs" {
  type = list(string)
  default = ["10.0.0.0/24","10.0.1.0/24"]
}

variable "private_cidrs" {
  type    = list(string)
  default = ["10.0.2.0/24","10.0.3.0/24"]
}
variable "access_ip" {
  type    = string
  default = "172.31.53.90/32" # by presenting ec2 instances private ip
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vol_size" {
  type    = number
  default = 8
}

variable "instance_count" {
  type    = number
  default = 3
}

variable "key_name" {
  type    = string
  default = "terraform"
}




variable "cloud_env" {
  type    = string
  description = "Enter the Environment ( dev/qa/prod)."
  default = "dev"
}



