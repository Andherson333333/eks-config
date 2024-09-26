module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  # Basic configuration
  name           = "${local.name}-efs"
  creation_token = "${local.name}-efs-token"
  encrypted      = true

  # VPC and subnet connection
  # Creates mount targets in each AZ's private subnet
  mount_targets = {
    for az, subnet_id in zipmap(module.vpc.azs, module.vpc.private_subnets) : az => { subnet_id = subnet_id }
  }

  # Lifecycle policy
  # Transitions files to IA storage class after 30 days of inactivity
  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  # Security configuration
  security_group_description = "${local.name} EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  # Access point for EKS
  # Creates a dedicated access point for EKS with specific POSIX user and root directory settings
  access_points = {
    eks = {
      posix_user = {
        gid = 1000
        uid = 1000
      }
      root_directory = {
        path = "/eks"
        creation_info = {
          owner_gid   = 1000
          owner_uid   = 1000
          permissions = "755"
        }
      }
    }
  }

  # Enable backup policy
  enable_backup_policy = true

  # Tags
  # Merges local tags with EFS-specific tags
  tags = merge(local.tags, {
    Terraform = "true"
    Cluster   = module.eks.cluster_name
  })
}
