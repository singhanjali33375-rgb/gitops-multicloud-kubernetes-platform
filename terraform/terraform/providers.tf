terraform {
  required_version = ">= 1.6.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }

  }
}

############################
# AWS Provider
############################

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Anjali Singh"
    }
  }
}

############################
# Azure Provider
############################

provider "azurerm" {
  features {}
}

############################
# Google Cloud Provider
############################

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

############################
# Kubernetes Provider
############################

provider "kubernetes" {
  config_path = "~/.kube/config"
}

############################
# Helm Provider
############################

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
