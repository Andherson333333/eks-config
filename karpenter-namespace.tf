# Create Namespace for karpenter install
resource "kubectl_manifest" "karpenter_namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: karpenter
  YAML

  depends_on = [module.eks]
}
