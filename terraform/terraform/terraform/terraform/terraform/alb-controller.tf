############################################################
# AWS Load Balancer Controller
# Part 1/3
############################################################

provider "helm" {

  kubernetes {

    host = aws_eks_cluster.this.endpoint

    cluster_ca_certificate = base64decode(
      aws_eks_cluster.this.certificate_authority[0].data
    )

    exec {

      api_version = "client.authentication.k8s.io/v1beta1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        var.cluster_name
      ]

    }

  }

}


############################################################
# Kubernetes Namespace
############################################################

resource "kubernetes_namespace" "aws_load_balancer_controller" {

  metadata {

    name = "kube-system"

  }

}
############################################################
# AWS Load Balancer Controller Helm Release
# Part 2/3
############################################################

resource "helm_release" "aws_load_balancer_controller" {

  name = "aws-load-balancer-controller"

  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  version = "1.8.1"


  values = [

    yamlencode({

      clusterName = var.cluster_name


      serviceAccount = {

        create = true

        name = "aws-load-balancer-controller"


        annotations = {

          "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn

        }

      }


      region = var.aws_region


      vpcId = var.vpc_id


    })

  ]


  depends_on = [

    aws_iam_role_policy_attachment.alb_controller

  ]

}
############################################################
# AWS Load Balancer Controller
# Part 3/3
############################################################


############################################################
# Controller Service Account
############################################################

data "kubernetes_service_account" "alb_controller" {

  metadata {

    name = "aws-load-balancer-controller"

    namespace = "kube-system"

  }


  depends_on = [

    helm_release.aws_load_balancer_controller

  ]

}


############################################################
# Helm Release Output
############################################################

output "alb_controller_release_name" {

  description = "AWS Load Balancer Controller Helm Release"

  value = helm_release.aws_load_balancer_controller.name

}


############################################################
# Namespace Output
############################################################

output "alb_controller_namespace" {

  description = "Namespace where ALB Controller is installed"

  value = helm_release.aws_load_balancer_controller.namespace

}


############################################################
# Controller Service Account Name
############################################################

output "alb_controller_service_account" {

  description = "ALB Controller Service Account"

  value = data.kubernetes_service_account.alb_controller.metadata[0].name

}
