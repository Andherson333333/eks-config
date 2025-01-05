resource "kubectl_manifest" "service_account" {
  yaml_body = <<-YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: s3-csi-controller-sa
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${module.mountpoint-s3-csi.iam_role_arn}
YAML
}

resource "kubectl_manifest" "s3_storage_class" {
  yaml_body = <<-YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: s3-storage
provisioner: s3.csi.aws.com
parameters:
  bucketName: ${aws_s3_bucket.s3_bucket.id}
YAML
}
