terraform {
  backend "s3" {
    bucket         = "taskapp-tsa-terra-terraform-state"
    key            = "root/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "taskapp-tsa-terra-terraform-locks"
    encrypt        = true
  }
}
