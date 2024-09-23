output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.tf-practic-ec2.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.tf-practic-ec2.id
}

output "vpc_id" {
  value = aws_vpc.tf-practic-vpc.id
}