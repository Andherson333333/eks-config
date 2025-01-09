resource "helm_release" "external_nginx" {
  name              = "external"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  namespace         = "ingress-nginx-external"
  create_namespace  = true
  version           = "4.12.0"

  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx-external"
  }

  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/ingress-nginx-external"
  }

  set {
    name  = "controller.watchIngressWithoutClass"
    value = "false"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-deletion-protection"
    value = "false"
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
