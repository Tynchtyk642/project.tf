variable "ami" {
  description = "AMI"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name for instance"
  type        = string
  default     = "Ec2"
}

variable "sg_name" {
  description = "Name for SG"
  type        = string
  default     = "SG"
}

variable "sg_ports" {
  description = "Some ports for Security Groups"
  type = list
  default = ["80", "22", "443"]
}

variable "cidr_sg" {
  description = "CIDR for SG"
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "cidr_vpc" {
  description = "CIDR for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name for VPC"
  type = string
  default = "my_vpc"
}

variable "cidr_subnet" {
  description = "CIDR for subnet"
  type = string
  default = "10.0.1.0/24"
}

variable "protocol" {
  description = "SG protocol"
  type = string
  default = "tcp"
}

variable "user_data" {
  description = "user data"
  type = any
  default = null
}