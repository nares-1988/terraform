resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST" # No need to provision capacity, it scales automatically
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"  # 'S' means string type for the hash key
  }

  tags = {
    Name = "TerraformStateLock"
    Environment = "Development"
  }
}
