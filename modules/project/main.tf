# terraform {
#   backend "s3" {
#     bucket = "dev-project-q"
#     key = "dev/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

#====================VPC==========================
resource "aws_vpc" "my_vpc_1" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}


#=======================IGW=========================
resource "aws_internet_gateway" "gw_1" {
  vpc_id = aws_vpc.my_vpc_1.id
}


#=====================subnet===========================
resource "aws_subnet" "tf_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc_1.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw_1]
}


#======================EC2============================

resource "aws_instance" "my_ec2_1" {
  # us-west-2
  ami           = var.ami
  instance_type = var.instance_type

  # private_ip = "10.0.0.12"
  subnet_id  = aws_subnet.tf_subnet_1.id
  vpc_security_group_ids = [aws_security_group.terraform_sg_1.id]
  user_data = var.user_data
  private_ip = "10.0.1.12"

  tags = {
    "Name" = var.instance_name
  }
}


#=========================EIP=============================
resource "aws_eip" "eip_1" {
  vpc = true

  instance                  = aws_instance.my_ec2_1.id
  associate_with_private_ip = "10.0.1.12"
  depends_on                = [aws_internet_gateway.gw_1]
}




#=======================SG===================================
resource "aws_security_group" "terraform_sg_1" {
  name = var.sg_name
  description = "Security Group for my_ec2"
  vpc_id = aws_vpc.my_vpc_1.id
  
  dynamic "ingress" {
  for_each = var.sg_ports
  content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = var.protocol
      cidr_blocks = ["0.0.0.0/0"]
  }
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

#===============ROUTE-TABLE=========================

resource "aws_route_table" "tf_subnet_1" {
  vpc_id = aws_vpc.my_vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_1.id
  }

  tags = {
    "Name" = "Public Subnet's route table"
  }
}

resource "aws_route_table_association" "tf_subnet_1" {
  subnet_id      = aws_subnet.tf_subnet_1.id
  route_table_id = aws_route_table.tf_subnet_1.id
}

