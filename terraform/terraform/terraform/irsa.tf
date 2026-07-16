###########################################################
# External DNS IRSA
###########################################################

data "aws_iam_policy_document" "external_dns_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:external-dns"
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

  }

}

###########################################################
# External DNS IAM Role
###########################################################

resource "aws_iam_role" "external_dns" {

  name = "${var.cluster_name}-external-dns-irsa"

  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role.json

  tags = {

    Name       = "${var.cluster_name}-external-dns"

    Terraform  = "true"

    Environment = var.environment

  }

}

###########################################################
# External DNS IAM Policy
###########################################################

resource "aws_iam_policy" "external_dns" {

  name        = "${var.cluster_name}-external-dns-policy"

  description = "IAM Policy for External DNS"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "route53:ChangeResourceRecordSets"

        ]

        Resource = [

          "arn:aws:route53:::hostedzone/*"

        ]

      },

      {

        Effect = "Allow"

        Action = [

          "route53:ListHostedZones",

          "route53:ListHostedZonesByName",

          "route53:ListResourceRecordSets",

          "route53:ListTagsForResource"

        ]

        Resource = "*"

      }

    ]

  })

}

###########################################################
# Attach Policy
###########################################################

resource "aws_iam_role_policy_attachment" "external_dns" {

  role = aws_iam_role.external_dns.name

  policy_arn = aws_iam_policy.external_dns.arn

}

###########################################################
# Output
###########################################################

output "external_dns_role_arn" {

  value = aws_iam_role.external_dns.arn

}
############################################################
# AWS Load Balancer Controller IRSA
############################################################

✔ Assume Role Policy
✔ IAM Role
✔ IAM Policy
✔ Policy Attachment
✔ Output
data "aws_iam_policy_document" "alb_controller_assume_role"

resource "aws_iam_role" "alb_controller"

resource "aws_iam_policy" "alb_controller"

resource "aws_iam_role_policy_attachment" "alb_controller"

output "alb_controller_role_arn"

###########################################################
# EBS CSI Driver IRSA
###########################################################

data "aws_iam_policy_document" "ebs_csi_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]

    }

  }

}

###########################################################
# EBS CSI IAM Role
###########################################################

resource "aws_iam_role" "ebs_csi" {

  name = "${var.cluster_name}-ebs-csi-irsa"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json

  tags = {
    Name        = "${var.cluster_name}-ebs-csi"
    Terraform   = "true"
    Environment = var.environment
  }

}

###########################################################
# Attach AWS Managed Policy
###########################################################

resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}

###########################################################
# Output
###########################################################

output "ebs_csi_role_arn" {

  description = "EBS CSI Driver IRSA Role ARN"

  value = aws_iam_role.ebs_csi.arn

}

############################################################
# Karpenter IRSA
############################################################

data "aws_iam_policy_document" "karpenter_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url,"https://","")}:sub"

      values = [
        "system:serviceaccount:karpenter:karpenter"
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url,"https://","")}:aud"

      values = [
        "sts.amazonaws.com"
      ]

    }

  }

}

############################################################
# Karpenter IAM Role
############################################################

resource "aws_iam_role" "karpenter" {

  name = "${var.cluster_name}-karpenter-irsa"

  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json

  tags = {

    Name        = "${var.cluster_name}-karpenter"

    Terraform   = "true"

    Environment = var.environment

  }

}

############################################################
# Karpenter IAM Policy (Template)
############################################################

resource "aws_iam_policy" "karpenter" {

  name        = "${var.cluster_name}-karpenter-policy"

  description = "IAM Policy for Karpenter Controller"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:CreateLaunchTemplate",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts",
          "ssm:GetParameter",
          "iam:PassRole"

        ]

        Resource = "*"

      }

    ]

  })

}

############################################################
# Attach Policy
############################################################

resource "aws_iam_role_policy_attachment" "karpenter" {

  role = aws_iam_role.karpenter.name

  policy_arn = aws_iam_policy.karpenter.arn

}

############################################################
# Attach AWS Managed Policy
############################################################

resource "aws_iam_role_policy_attachment" "karpenter_ssm" {

  role = aws_iam_role.karpenter.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

############################################################
# Output
############################################################

output "karpenter_role_arn" {

  description = "Karpenter IRSA Role ARN"

  value = aws_iam_role.karpenter.arn

}

############################################################
# Cluster Autoscaler IRSA
############################################################

data "aws_iam_policy_document" "cluster_autoscaler_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url,"https://","")}:sub"

      values = [
        "system:serviceaccount:kube-system:cluster-autoscaler"
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url,"https://","")}:aud"

      values = [
        "sts.amazonaws.com"
      ]

    }

  }

}

############################################################
# Cluster Autoscaler IAM Role
############################################################

resource "aws_iam_role" "cluster_autoscaler" {

  name = "${var.cluster_name}-cluster-autoscaler-irsa"

  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role.json

  tags = {

    Name        = "${var.cluster_name}-cluster-autoscaler"

    Terraform   = "true"

    Environment = var.environment

  }

}

############################################################
# Cluster Autoscaler IAM Policy
############################################################

resource "aws_iam_policy" "cluster_autoscaler" {

  name = "${var.cluster_name}-cluster-autoscaler-policy"

  description = "IAM policy for Kubernetes Cluster Autoscaler"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstanceTypes"

        ]

        Resource = "*"

      }

    ]

  })

}

############################################################
# Attach Policy
############################################################

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {

  role = aws_iam_role.cluster_autoscaler.name

  policy_arn = aws_iam_policy.cluster_autoscaler.arn

}

############################################################
# Output
############################################################

output "cluster_autoscaler_role_arn" {

  description = "Cluster Autoscaler IRSA Role ARN"

  value = aws_iam_role.cluster_autoscaler.arn

}
