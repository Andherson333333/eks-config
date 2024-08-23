# AWS Module loadbalancer controler
module "aws_lb_controller_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.4.0"

  name = "aws-lbc"
  attach_aws_lb_controller_policy = true


  # Configuración por defecto para las asociaciones de identidad
  association_defaults = {
    namespace       = "kube-system"
    service_account = "aws-load-balancer-controller"
  }

  associations = {
    eks_one = {
      cluster_name = module.eks.cluster_name
    }
  }

  tags = local.tags

  depends_on = [module.eks]
}
