terraform {
  backend "s3" {
    bucket         = "multi-tier-terraform-state-q"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-q"
    encrypt        = true
  }
}