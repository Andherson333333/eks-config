module "aurora_postgresql" {
 source  = "terraform-aws-modules/rds-aurora/aws"
 version = "~> 9.0"

 name           = lower(replace("${local.name}-aurora-postgresql", "-", ""))
 engine         = "aurora-postgresql"
 engine_version = "15.5"
 instance_class = "db.t3.medium"

 # Configuración de instancias primaria y réplica
 instances = {
   primary = {}
   replica = {}
 }

 # VPC Configuration
 vpc_id               = module.vpc.vpc_id
 db_subnet_group_name = module.vpc.database_subnet_group_name

 # Initial Database Setup
 database_name          = "mydb"
 master_username        = "dbadmin"
 manage_master_user_password = true

 # Monitoring and Logs
 monitoring_interval = 60
 enabled_cloudwatch_logs_exports = ["postgresql"]
 create_cloudwatch_log_group = true
 cloudwatch_log_group_retention_in_days = 7

 # Backup Configuration
 backup_retention_period = 7
 preferred_backup_window = "02:00-03:00"

 # Grupos de parámetros
 create_db_cluster_parameter_group = true
 db_cluster_parameter_group_family = "aurora-postgresql15"
 create_db_parameter_group = true
 db_parameter_group_family = "aurora-postgresql15"

 # Security Configuration
 storage_encrypted = true

 # Reglas de seguridad para acceso desde EKS
 # Es necesario permitir tanto el acceso desde el plano de control (cluster_security_group_id)
 # como desde los nodos de trabajo (node_security_group_id) donde se ejecutan los pods
 security_group_rules = {
   eks_cluster_ingress = {
     source_security_group_id = module.eks.cluster_security_group_id  # Acceso desde el plano de control
   }
   eks_nodes_ingress = {
     source_security_group_id = module.eks.node_security_group_id     # Acceso desde los nodos donde corren los pods
   }
 }

 tags = local.tags
}
