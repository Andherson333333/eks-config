resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "62.6.0"  # Verifica la última versión disponible
  namespace  = "monitoring"

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp3-default"
  }

  set {
    name  = "grafana.persistence.storageClassName"
    value = "gp3-default"
  }

  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "30d"
  }


  depends_on = [module.eks, kubectl_manifest.prometheus_namespace]
}
