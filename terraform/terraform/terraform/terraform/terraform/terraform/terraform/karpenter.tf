############################################################
# Karpenter
# Part 1/4
############################################################


############################################################
# Karpenter Namespace
############################################################

resource "kubernetes_namespace" "karpenter" {

  metadata {

    name = "karpenter"

  }

}


############################################################
# Karpenter Helm Release
############################################################

resource "helm_release" "karpenter" {

  name = "karpenter"

  namespace = kubernetes_namespace.karpenter.metadata[0].name


  repository = "oci://public.ecr.aws/karpenter"

  chart = "karpenter"


  version = "1.0.0"


  values = [

    yamlencode({

      settings = {

        clusterName = var.cluster_name

        clusterEndpoint = aws_eks_cluster.this.endpoint

      }


      serviceAccount = {

        create = true

        name = "karpenter"


        annotations = {

          "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter.arn

        }

      }


    })

  ]


  depends_on = [

    aws_iam_role_policy_attachment.karpenter

  ]

}
############################################################
# Karpenter
# Part 2/4
############################################################


############################################################
# Karpenter EC2NodeClass
############################################################

resource "kubernetes_manifest" "karpenter_node_class" {

  manifest = {

    apiVersion = "karpenter.k8s.aws/v1"

    kind = "EC2NodeClass"


    metadata = {

      name = "default"

    }


    spec = {


      amiFamily = "AL2023"


      role = aws_iam_role.karpenter.name


      subnetSelectorTerms = [

        {

          tags = {

            "karpenter.sh/discovery" = var.cluster_name

          }

        }

      ]


      securityGroupSelectorTerms = [

        {

          tags = {

            "karpenter.sh/discovery" = var.cluster_name

          }

        }

      ]


      tags = {

        Name = "${var.cluster_name}-karpenter-node"

        Environment = var.environment

      }


    }

  }


  depends_on = [

    helm_release.karpenter

  ]

}
############################################################
# Karpenter
# Part 3/4
############################################################


############################################################
# Karpenter NodePool
############################################################

resource "kubernetes_manifest" "karpenter_node_pool" {

  manifest = {

    apiVersion = "karpenter.sh/v1"

    kind = "NodePool"


    metadata = {

      name = "default"

    }


    spec = {


      template = {

        metadata = {

          labels = {

            "managed-by" = "karpenter"

          }

        }


        spec = {


          nodeClassRef = {

            name = "default"

            group = "karpenter.k8s.aws"

            kind = "EC2NodeClass"

          }


          requirements = [

            {

              key = "kubernetes.io/arch"

              operator = "In"

              values = [

                "amd64"

              ]

            },


            {

              key = "karpenter.sh/capacity-type"

              operator = "In"

              values = [

                "spot",

                "on-demand"

              ]

            },


            {

              key = "node.kubernetes.io/instance-type"

              operator = "In"

              values = [

                "t3.small",

                "t3.medium"

              ]

            }

          ]

        }

      }


      limits = {

        cpu = "1000"

      }


      disruption = {

        consolidationPolicy = "WhenEmptyOrUnderutilized"

      }

    }

  }


  depends_on = [

    kubernetes_manifest.karpenter_node_class

  ]

}
############################################################
# Karpenter
# Part 4/4
############################################################


############################################################
# Karpenter IAM Role Output
############################################################

output "karpenter_irsa_role_arn" {

  description = "Karpenter Controller IRSA Role ARN"

  value = aws_iam_role.karpenter.arn

}


############################################################
# Karpenter Namespace Output
############################################################

output "karpenter_namespace" {

  description = "Karpenter Namespace"

  value = kubernetes_namespace.karpenter.metadata[0].name

}


############################################################
# Karpenter Helm Release Output
############################################################

output "karpenter_release_name" {

  description = "Karpenter Helm Release Name"

  value = helm_release.karpenter.name

}
