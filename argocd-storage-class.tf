resource "kubectl_manifest" "argocd_pvc" {
  yaml_body = <<-YAML
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: argocd-pvc
    namespace: argocd
  spec:
    accessModes:
      - ReadWriteOnce
    storageClassName: gp3-default
    resources:
      requests:
        storage: 8Gi
  YAML

  depends_on = [
    kubernetes_namespace.argocd,
    kubectl_manifest.ebs_csi_default_storage_class
  ]
}
