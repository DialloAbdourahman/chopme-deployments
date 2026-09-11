terraform {
  backend "s3" {
    bucket               = "chopme-terraform-state-xyz"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "chopme"
    region               = "eu-west-3"
    dynamodb_table       = "chopme-terraform-lock"
  }
}
