resource "helm_release" "prometheus_stack" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "68.2.1"
  namespace        = "monitoring"
  create_namespace = true

  # Configuraciones básicas de ServiceMonitor y PodMonitor
  set {
    name  = "serviceMonitor.metadata.labels.release"
    value = "prometheus"
  }

  set {
    name  = "podMonitor.metadata.labels.release"
    value = "prometheus"
  }
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "15d"
  }

  # Configuración de almacenamiento para Prometheus
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp3-default"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }

  # Configuración de almacenamiento para Grafana
  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }
  set {
    name  = "grafana.persistence.storageClassName"
    value = "gp3-default"
  }
  set {
    name  = "grafana.persistence.size"
    value = "10Gi"
  }

  depends_on = [
    helm_release.aws_lbc,
    helm_release.external_nginx
  ]
}
