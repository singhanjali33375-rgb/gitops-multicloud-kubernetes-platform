
############################################################
# Project Outputs
############################################################

output "project_name" {

  description = "Project Name"

  value = var.project_name

}


output "environment" {

  description = "Environment"

  value = var.environment

}


############################################################
# AWS Outputs
############################################################

output "aws_region" {

  description = "AWS Region"

  value = var.aws_region

}


output "cluster_name" {

  description = "EKS Cluster Name"

  value = var.cluster_name

}


############################################################
# Network Outputs
############################################################

output "vpc_id" {

  description = "VPC ID"

  value = var.vpc_id

}


############################################################
# Multi Cloud Outputs
############################################################

output "gcp_project" {

  description = "GCP Project ID"

  value = var.gcp_project

}


output "gcp_region" {

  description = "GCP Region"

  value = var.gcp_region

}


output "azure_location" {

  description = "Azure Location"

  value = var.azure_location

}
