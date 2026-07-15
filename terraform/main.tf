module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  cidr_block = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

module "eks" {
  source = "./modules/eks"

  project_name = var.project_name
  environment  = var.environment

  cluster_name = "gitops-eks"

  subnet_ids = module.vpc.private_subnet_ids

  vpc_id = module.vpc.vpc_id
}
