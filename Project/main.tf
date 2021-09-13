provider "aws" {
  region = "us-east-1"
}

# locals {
#   instance_name = "${terraform.workspace} - instance"
# }

terraform { 
  backend "s3" {
  bucket = "sam.and.writer"
  key = "terraform.tfstate"
  region = "us-east-1"
}
}

data "aws_ami" "amazon_ubuntu" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210430"]
    }
}

module "project" {
  source = "../modules/project"
  ami = data.aws_ami.amazon_ubuntu.id
  user_data = file("C:/Users/Ant/OneDrive/Рабочий стол/Project.tf/project.tf/project/user_data.sh")
  instance_type = "t2.micro"
}

output "public_ip" {
  value = module.project.EIP
}