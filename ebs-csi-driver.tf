module "eks-pod-identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.4.0"

  name = "aws-ebs-csi"
  attach_aws_ebs_csi_policy = true

  # Pod Identity Associations
  association_defaults = {
    namespace       = "kube-system"
    service_account = "ebs-csi-controller-sa"

  }

  associations = {
    ex-one = {
      cluster_name = module.eks.cluster_name
    }
  }

  tags = local.tags
}
