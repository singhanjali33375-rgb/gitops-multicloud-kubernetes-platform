terraform {

  backend "s3" {

    bucket = "terraform-state-bucket"

    key = "gitops-platform/terraform.tfstate"

    region = "ap-south-1"

    encrypt = true

  }

}
