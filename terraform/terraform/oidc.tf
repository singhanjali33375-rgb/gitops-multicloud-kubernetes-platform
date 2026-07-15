########################################
# Get EKS Cluster Information
########################################

data "aws_eks_cluster" "main" {
  name = aws_eks_cluster.main.name
}

########################################
# TLS Certificate
########################################

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer
}

########################################
# OIDC Provider
########################################

resource "aws_iam_openid_connect_provider" "eks" {

  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name        = "${var.project_name}-oidc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

########################################
# Outputs
########################################

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "
