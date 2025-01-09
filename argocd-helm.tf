resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "7.7.13"
  create_namespace = true

  set {
    name  = "redis.enabled"
    value = "true"
  }

  set {
    name  = "redis.persistence.enabled"
    value = "true"
  }

  set {
    name  = "redis.persistence.existingClaim"
    value = "argocd-pvc"
  }

  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  # Agregar estas configuraciones para el basePath

  set {
    name  = "configs.params.server\\.basehref"
    value = "/argocd"
  }

  set {
    name  = "server.basePath"
    value = "/argocd"
  }

  set {
    name  = "server.baseUrl"
    value = "/argocd"
  }

  depends_on = [
    kubectl_manifest.argocd_pvc,
    helm_release.nginx_internal,
    helm_release.external_nginx
  ]
}
