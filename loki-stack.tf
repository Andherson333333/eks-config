resource "helm_release" "loki_stack" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  namespace        = "monitoring"
  version          = "2.10.2"
  create_namespace = true

  set {
    name  = "loki.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.storageClassName"
    value = "gp3-default"
  }

  set {
    name  = "loki.persistence.size"
    value = "10Gi"
  }

  values = [
    <<-EOT
    promtail:
      config:
        snippets:
          extraRelabelConfigs:
            - source_labels: [__meta_kubernetes_namespace]
              target_label: namespace
            - source_labels: [__meta_kubernetes_pod_name]
              target_label: pod
            - source_labels: [__meta_kubernetes_pod_container_name]
              target_label: container
            - source_labels: [__meta_kubernetes_pod_container_name]
              target_label: log_type
              action: replace
              regex: istio-proxy
              replacement: envoy
            - source_labels: [__meta_kubernetes_pod_container_name]
              target_label: log_type
              action: replace
              regex: .+
              replacement: application
    EOT
  ]

  depends_on = [
    module.eks,
    helm_release.prometheus_stack
  ]
}
