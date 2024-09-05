terraform {
  backend "s3" {
    bucket  = "my-terraform-state-file-store-bucket"
    key     = "jenkins/terraform.tfstate"
    encrypt = true
    region  = "us-east-1"
  }
}
