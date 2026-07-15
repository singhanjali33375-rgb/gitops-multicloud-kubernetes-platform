########################################
# EKS Managed Node Group
########################################

resource "aws_eks_node_group" "main" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${var.project_name}-node-group"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = [

    aws_subnet.private_1.id,

    aws_subnet.private_2.id

  ]

  ami_type = "AL2023_x86_64_STANDARD"

  capacity_type = "ON_DEMAND"

  instance_types = [

    "t3.medium"

  ]

  disk_size = 30

  scaling_config {

    desired_size = 2

    min_size = 2

    max_size = 4

  }

  update_config {

    max_unavailable = 1

  }

  labels = {

    environment = var.environment

    nodegroup = "primary"

  }

  tags = {

    Name = "${var.project_name}-node-group"

    Environment = var.environment

    ManagedBy = "Terraform"

  }

  depends_on = [

    aws_iam_role_policy_attachment.worker_node_policy,

    aws_iam_role_policy_attachment.cni_policy,

    aws_iam_role_policy_attachment.ecr_readonly,

    aws_iam_role_policy_attachment.ssm_core

  ]

}
