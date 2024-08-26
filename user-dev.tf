# Crear política para desarrollador EKS
module "developer_eks_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.3.1"
  name          = "AmazonEKSDeveloperPolicy"
  create_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

# Crear usuario desarrollador
module "developer_iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.1"
  name                          = "developer"
  create_iam_access_key         = false
  create_iam_user_login_profile = false
  force_destroy                 = true
}

# Crear grupo para desarrolladores EKS
module "eks_developers_iam_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.3.1"
  name                              = "eks-developer"
  attach_iam_self_management_policy = false
  create_group                      = true
  group_users                       = [module.developer_iam_user.iam_user_name]
  custom_group_policy_arns          = [module.developer_eks_policy.arn]
}

# Configurar acceso al cluster EKS
resource "aws_eks_access_entry" "developer" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = module.developer_iam_user.iam_user_arn
  kubernetes_groups = ["my-viewer"]
  type              = "STANDARD"
}
