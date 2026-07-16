############################################################
# External DNS
# Part 1/3
############################################################


############################################################
# External DNS Namespace
############################################################

resource "kubernetes_namespace" "external_dns" {

  metadata {

    name = "external-dns"

  }

}


############################################################
# External DNS Helm Release
############################################################

resource "helm_release" "external_dns" {

  name = "external-dns"

  namespace = kubernetes_namespace.external_dns.metadata[0].name


  repository = "https://kubernetes-sigs.github.io/external-dns/"

  chart = "external-dns"


  version = "1.14.5"


  create_namespace = false


  depends_on = [

    kubernetes_namespace.external_dns

  ]

}
############################################################
# External DNS
# Part 2/3
############################################################


resource "helm_release" "external_dns_configured" {

  name = "external-dns"

  namespace = kubernetes_namespace.external_dns.metadata[0].name


  repository = "https://kubernetes-sigs.github.io/external-dns/"

  chart = "external-dns"


  version = "1.14.5"


  values = [

    yamlencode({

      provider = "aws"


      aws = {

        zoneType = "public"

      }


      policy = "sync"


      registry = "txt"


      txtOwnerId = var.cluster_name


      serviceAccount = {

        create = true

        name = "external-dns"


        annotations = {

          "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn

        }

      }


      domainFilters = [

        var.domain_name

      ]


      sources = [

        "service",

        "ingress"

      ]


    })

  ]


  depends_on = [

    aws_iam_role_policy_attachment.external_dns

  ]

}
############################################################
# External DNS
# Part 3/3
############################################################


############################################################
# External DNS Release Output
############################################################

output "external_dns_release_name" {

  description = "External DNS Helm Release Name"

  value = helm_release.external_dns.name

}


############################################################
# External DNS Namespace Output
############################################################

output "external_dns_namespace" {

  description = "External DNS Namespace"

  value = kubernetes_namespace.external_dns.metadata[0].name

}


############################################################
# External DNS Role ARN Output
############################################################

output "external_dns_irsa_role_arn" {

  description = "External DNS IRSA IAM Role ARN"

  value = aws_iam_role.external_dns.arn

}
