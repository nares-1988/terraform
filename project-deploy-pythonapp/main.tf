provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "tf-key-pair" {
  key_name = "tf-key-pair"
  public_key = file("C:/Users/REMOTE/.ssh/id_rsa.pub")
}

resource "aws_vpc" "tf-project-vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "tf-project" {
  vpc_id = aws_vpc.tf-project-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "tf-project-igw" {
  vpc_id = aws_vpc.tf-project-vpc.id
}

resource "aws_route_table" "tf-project-rt" {
  vpc_id = aws_vpc.tf-project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-project-igw.id
  }
}

resource "aws_route_table_association" "tf-project-route-map" {
  subnet_id = aws_subnet.tf-project.id
  route_table_id = aws_route_table.tf-project-rt.id
}

resource "aws_security_group" "tf-project-sg" {
  name = "tf-project-sg"
  vpc_id = aws_vpc.tf-project-vpc.id

  ingress {
    description = "HTTP inbound allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSh allow"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    name = "tf-project-sg"
  }
}

resource "aws_instance" "tf-roject-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t3.micro"
  key_name = aws_key_pair.tf-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.tf-project-sg.id]
  subnet_id = aws_subnet.tf-project.id

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/REMOTE/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo apt install -y python3-flask",
      "sudo python3 app.py",
    ]
  }

}