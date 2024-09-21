terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-naresh"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}