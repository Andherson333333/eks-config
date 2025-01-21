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

  # Configuración de Prometheus
  set {
    name  = "prometheus.prometheusSpec.routePrefix"
    value = "/prometheus"
  }
  set {
    name  = "prometheus.service.port"
    value = "9090"
  }
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
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

  # Configuración de Grafana
  set {
    name  = "grafana.grafana\\.ini.server.root_url"
    value = "%(protocol)s://%(domain)s/grafana"
  }
  set {
    name  = "grafana.grafana\\.ini.server.serve_from_sub_path"
    value = "true"
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

  # Configuración para Alertmanager
  set {
    name  = "alertmanager.alertmanagerSpec.routePrefix"
    value = "/alertmanager"
  }

  # Configuraciones adicionales de monitoreo
  set {
    name  = "grafana.serviceMonitor.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
  set {
    name  = "prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues"
    value = "false"
  }

  depends_on = [
    helm_release.aws_lbc,
    helm_release.external_nginx
  ]
}
