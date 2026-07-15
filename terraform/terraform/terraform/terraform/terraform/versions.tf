terraform {
  required_version = ">=1.6.0"

  required_providers {

    aws = {
      source = "hashicorp/aws"
    }

    azurerm = {
      source = "hashicorp/azurerm"
    }

    google = {
      source = "hashicorp/google"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }

  }
}
