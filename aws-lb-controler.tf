# AWS Load Balancer Controller Module
module "aws_lb_controller_pod_identity" {
 source  = "terraform-aws-modules/eks-pod-identity/aws"
 version = "1.9.0"

 # Basic Configuration Block
 name = "aws-lbc"
 attach_aws_lb_controller_policy = true

 # Default Identity Association Settings
 association_defaults = {
   namespace       = "kube-system"
   service_account = "aws-load-balancer-controller" 
 }

 # Cluster Association Block
 associations = {
   eks_one = {
     cluster_name = module.eks.cluster_name
   }
 }

 tags = local.tags
 depends_on = [module.eks]
}
