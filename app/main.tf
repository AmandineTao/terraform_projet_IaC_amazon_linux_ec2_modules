terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  #define the remote backend
  backend "s3" {
    bucket = "terraform-backend-amandine"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}

#configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "security_group" {
  source = "../module/security_group"

  sg_tag = {
    Name = "sg_app_amandine"
  }

}

#include ec2 module
module "ec2_amazon_linux" {
  source = "../module/ec2_amazon_linux"

  #define the variables
  sg_name       = module.security_group.sg_name
  instance_type = "t2.micro"
  ec2_tag = {
    Name = "ec2_app_amandine"
  }
  key_name = "devops-amandine"
  key_path = "./devops-amandine.pem"
}


module "ip_lb" {
  source = "../module/ip_lb"

  ip_lb_tag = {
    Name = "ip_lb_app_amandine"
  }

}

module "ebs" {
  source = "../module/ebs"

  ebs_tag = {
    Name = "ebs_app_amandine"
  }
  ebs_availability_zone = "us-east-1a"
  ebs_size              = 10


}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2_amazon_linux.instance_id
  allocation_id = module.ip_lb.id
}