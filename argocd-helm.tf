# Base ArgoCD Installation Block
# Defines the main configuration for ArgoCD deployment
resource "helm_release" "argocd" {
 name             = "argocd"
 repository       = "https://argoproj.github.io/argo-helm"
 chart            = "argo-cd" 
 namespace        = "argocd"
 version          = "7.7.13"
 create_namespace = true

 # Storage Configuration Block
 # Sets up persistent storage settings for Redis
 set {
   name  = "redis.enabled"
   value = "true"
 }
 set {
   name  = "redis.persistence.enabled" 
   value = "true"
 }
 set {
   name  = "redis.persistence.storageClass"
   value = "gp3-default"
 }

 # ArgoCD Server Configuration Block
 # Configures core ArgoCD server settings
 set {
   name  = "configs.params.server\\.insecure"
   value = "true"
 }

 # Dependencies Block
 # Defines required resources that must exist first
 depends_on = [
   helm_release.nginx_internal,
   helm_release.external_nginx
 ]
}
