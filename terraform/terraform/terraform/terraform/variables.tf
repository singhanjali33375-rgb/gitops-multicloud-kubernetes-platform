############################################################
# Project Configuration
############################################################

variable "project_name" {

  description = "Project name"

  type = string

  default = "gitops-multicloud-kubernetes-platform"

}


variable "environment" {

  description = "Environment name"

  type = string

  default = "dev"

}


############################################################
# AWS Configuration
############################################################

variable "aws_region" {

  description = "AWS region"

  type = string

  default = "ap-south-1"

}


variable "cluster_name" {

  description = "EKS cluster name"

  type = string

  default = "gitops-multicloud-platform"

}


variable "vpc_id" {

  description = "Existing VPC ID"

  type = string

}


variable "domain_name" {

  description = "Domain name for External DNS"

  type = string

}


############################################################
# EKS OIDC / IRSA Configuration
############################################################

variable "oidc_provider_arn" {

  description = "EKS OIDC Provider ARN"

  type = string

}


variable "oidc_provider_url" {

  description = "EKS OIDC Provider URL"

  type = string

}


############################################################
# GCP Configuration
############################################################

variable "gcp_project" {

  description = "GCP Project ID"

  type = string

}


variable "gcp_region" {

  description = "GCP Region"

  type = string

  default = "asia-south1"

}


############################################################
# Azure Configuration
############################################################

variable "azure_location" {

  description = "Azure region"

  type = string

  default = "centralindia"

}
