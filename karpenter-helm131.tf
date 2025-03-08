resource "helm_release" "karpenter" {
  namespace           = "karpenter"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.3.1"
  wait                = false
  values = [
    <<-EOT
    serviceAccount:
      name: ${module.eks_karpenter.service_account}
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueueName: ${module.eks_karpenter.queue_name}
    EOT
  ]
  depends_on = [kubectl_manifest.karpenter_namespace, module.eks_karpenter]
}
