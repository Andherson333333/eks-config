# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]
# database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 56)]


  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # create_database_subnet_group       = true
  # create_database_subnet_route_table = true


  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "subnet_type"            = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"         = local.name
  }

  # database_subnet_tags = {
  #    "subnet_type" = "database"
  # }
 
  tags = local.tags
}

