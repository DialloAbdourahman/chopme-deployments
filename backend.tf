terraform {
  backend "s3" {
    bucket               = "chopme-terraform-state-bucket"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "chopme"
    region               = "eu-west-3"
    use_lockfile         = true
  }
}
