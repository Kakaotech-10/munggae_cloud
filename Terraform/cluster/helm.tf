#resource "helm_release" "argocd" {
#  name       = "argocd"
#  chart      = "argo-cd"
#  namespace  = "argocd"
#  repository = "https://argoproj.github.io/argo-helm"
#  version    = "5.6.0"
#  create_namespace = true
#
#  set {
#    name  = "server.service.type"
#    value = "LoadBalancer"
#  }
#}

