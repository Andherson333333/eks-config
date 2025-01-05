module "mountpoint-s3-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.52.0"

  role_name = "${local.name}-s3-csi"

  attach_mountpoint_s3_csi_policy = true

  mountpoint_s3_csi_bucket_arns = [aws_s3_bucket.s3_bucket.arn]
  mountpoint_s3_csi_path_arns   = ["${aws_s3_bucket.s3_bucket.arn}/*"]

  # Configuración del proveedor OIDC
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:s3-csi-controller-sa"]
    }
  }

  tags = local.tags
}
