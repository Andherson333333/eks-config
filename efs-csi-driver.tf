# module efs
module "eks_efs_csi_driver" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.4.1"

  name = "aws-efs-csi-driver"

  attach_aws_efs_csi_policy = true

  # Pod Identity Associations
  association_defaults = {
    namespace       = "kube-system"
    service_account = "efs-csi-controller-sa"
  }

  associations = {
    efs_csi = {
      cluster_name = module.eks.cluster_name
    }
  }

  tags = local.tags
}
