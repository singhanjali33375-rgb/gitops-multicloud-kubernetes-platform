########################################
# EKS Control Plane Security Group
########################################

resource "aws_security_group" "eks_cluster_sg" {

  name        = "${var.project_name}-eks-cluster-sg"

  description = "Security Group for EKS Control Plane"

  vpc_id      = aws_vpc.main.id

  tags = {

    Name = "${var.project_name}-eks-cluster-sg"

    Environment = var.environment

  }

}

########################################
# Allow HTTPS to Kubernetes API
########################################

resource "aws_security_group_rule" "eks_api_ingress" {

  type              = "ingress"

  from_port         = 443

  to_port           = 443

  protocol          = "tcp"

  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.eks_cluster_sg.id

}

########################################
# Worker Node Security Group
########################################

resource "aws_security_group" "worker_nodes_sg" {

  name        = "${var.project_name}-worker-node-sg"

  description = "Worker Node Security Group"

  vpc_id      = aws_vpc.main.id

  tags = {

    Name = "${var.project_name}-worker-node-sg"

  }

}

########################################
# Node to Node Communication
########################################

resource "aws_security_group_rule" "worker_node_ingress" {

  type                     = "ingress"

  from_port                = 0

  to_port                  = 65535

  protocol                 = "tcp"

  self                     = true

  security_group_id        = aws_security_group.worker_nodes_sg.id

}

########################################
# Control Plane -> Worker Nodes
########################################

resource "aws_security_group_rule" "cluster_to_node" {

  type                     = "ingress"

  from_port                = 1025

  to_port                  = 65535

  protocol                 = "tcp"

  source_security_group_id = aws_security_group.eks_cluster_sg.id

  security_group_id        = aws_security_group.worker_nodes_sg.id

}

########################################
# Worker Nodes -> Control Plane
########################################

resource "aws_security_group_rule" "node_to_cluster" {

  type                     = "ingress"

  from_port                = 443

  to_port                  = 443

  protocol                 = "tcp"

  source_security_group_id = aws_security_group.worker_nodes_sg.id

  security_group_id        = aws_security_group.eks_cluster_sg.id

}

########################################
# Allow All Outbound
########################################

resource "aws_security_group_rule" "cluster_egress" {

  type              = "egress"

  from_port         = 0

  to_port           = 0

  protocol          = "-1"

  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.eks_cluster_sg.id

}

resource "aws_security_group_rule" "worker_egress" {

  type              = "egress"

  from_port         = 0

  to_port           = 0

  protocol          = "-1"

  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.worker_nodes_sg.id

}
