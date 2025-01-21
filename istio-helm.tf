# Instalar Istio base usando Helm
resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.24.2"

  depends_on = [
    module.eks,
#    helm_release.aws_lbc,
#    helm_release.external_nginx
  ]
}

# Instalar Istiod usando Helm
resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.24.2"

  set {
    name  = "meshConfig.enableTracing"
    value = "true"
  }

  set {
    name  = "meshConfig.extensionProviders[0].name"
    value = "jaeger"
  }

  set {
    name  = "meshConfig.extensionProviders[0].opentelemetry.port"
    value = "4317"
  }

  set {
    name  = "meshConfig.extensionProviders[0].opentelemetry.service"
    value = "jaeger-collector.istio-system.svc.cluster.local"
  }

  depends_on = [
    module.eks,
    helm_release.istio_base,
 #   helm_release.aws_lbc,
 #   helm_release.external_nginx
  ]
}
