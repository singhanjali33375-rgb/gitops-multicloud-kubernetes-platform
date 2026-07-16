############################################################
# CloudWatch Log Group for EKS
############################################################

resource "aws_cloudwatch_log_group" "eks_cluster" {

  name = "/aws/eks/${var.cluster_name}/cluster"

  retention_in_days = 30

  tags = {

    Name        = "${var.cluster_name}-eks-logs"

    Terraform   = "true"

    Environment = var.environment

  }

}

############################################################
# EKS Control Plane Logging Configuration
############################################################

locals {

  eks_control_plane_logs = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

}
############################################################
# EKS Logging
############################################################

enabled_cluster_log_types = local.eks_control_plane_logs

depends_on = [

  aws_cloudwatch_log_group.eks_cluster

]
############################################################
# CloudWatch Log Group Output
############################################################

output "eks_cloudwatch_log_group_name" {

  description = "EKS CloudWatch Log Group Name"

  value = aws_cloudwatch_log_group.eks_cluster.name

}


############################################################
# CloudWatch Log Group ARN Output
############################################################

output "eks_cloudwatch_log_group_arn" {

  description = "EKS CloudWatch Log Group ARN"

  value = aws_cloudwatch_log_group.eks_cluster.arn

}
