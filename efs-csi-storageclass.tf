resource "kubectl_manifest" "efs_storage_class" {
  yaml_body = <<-YAML
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: efs-sc
  provisioner: efs.csi.aws.com
  parameters:
    provisioningMode: efs-ap
    fileSystemId: ${module.efs.id}
    directoryPerms: "700"
    basePath: "/eks"
  YAML
  depends_on = [module.eks, module.efs]
}
