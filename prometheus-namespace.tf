# Create Namespace for Prometheus
resource "kubectl_manifest" "prometheus_namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: monitoring
  YAML
  depends_on = [module.eks]
}
