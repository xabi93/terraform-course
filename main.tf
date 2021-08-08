terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  profile = "xabi"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cdir_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
    source = "./modules/subnet"

    vpc_id = aws_vpc.myapp-vpc.id
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
}

module "myapp-server" {
  source = "./modules/webserver"

  vpc_id = aws_vpc.myapp-vpc.id
  my_ip = var.my_ip
  subnet_id = module.myapp-subnet.subnet.id
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
}
