provider "aws" {
  region = var.region_value
}

resource "aws_vpc" "tf-practic-vpc" {
    cidr_block = var.vpc_cidr_block_value
    tags = {
      name = "tf-practic-vpc"
    }
}

resource "aws_subnet" "tf-practic-subnet" {
  vpc_id = aws_vpc.tf-practic-vpc.id
  cidr_block = var.subnet_cidr_block_value
  map_public_ip_on_launch = true
}

resource "aws_instance" "tf-practic-ec2" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  subnet_id = aws_subnet.tf-practic-subnet.id
  tags = {
    name = "tf-practic-ec2"
  }
  associate_public_ip_address = true
}

