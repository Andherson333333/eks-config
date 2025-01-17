resource "kubectl_manifest" "ebs_csi_default_storage_class" {
  yaml_body = <<-YAML
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    annotations:
      storageclass.kubernetes.io/is-default-class: "true"
    name: gp3-default
  provisioner: ebs.csi.aws.com
  reclaimPolicy: Delete
  volumeBindingMode: WaitForFirstConsumer
  allowVolumeExpansion: true
  parameters:
    type: gp3  
    fsType: ext4
    encrypted: "true"
  YAML

  depends_on = [module.eks]
}
