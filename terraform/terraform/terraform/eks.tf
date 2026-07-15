########################################
# EKS Cluster
########################################

resource "aws_eks_cluster" "main" {

  name = "${var.project_name}-eks"

  version = "1.31"

  role_arn = aws_iam_role.eks_cluster_role.arn

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  vpc_config {

    subnet_ids = [

      aws_subnet.private_1.id,

      aws_subnet.private_2.id,

      aws_subnet.public_1.id,

      aws_subnet.public_2.id

    ]

    endpoint_private_access = true

    endpoint_public_access = true

    public_access_cidrs = [

      "0.0.0.0/0"

    ]

  }

  depends_on = [

    aws_iam_role_policy_attachment.cluster_policy,

    aws_iam_role_policy_attachment.vpc_controller

  ]

  tags = {

    Name = "${var.project_name}-eks"

    Environment = var.environment

  }

}
