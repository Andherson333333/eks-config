resource "helm_release" "nginx_internal" {
  name             = "nginx-internal"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx-internal"
  create_namespace = true
  version          = "4.12.0"

  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx-internal"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = "true"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }

#  set {
#    name  = "controller.service.ports.http"
#    value = "80"
#  }

   set {
    name  = "controller.service.enableHttp"
    value = "false"
  }



  set {
    name  = "controller.service.ports.https"
    value = "443"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "443"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"
  }

  depends_on = [helm_release.aws_lbc]
}
