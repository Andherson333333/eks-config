# NodePool para aplicaciones stateless
resource "kubectl_manifest" "karpenter_app_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: application
    spec:
      template:
        metadata:
          labels:
            node-type: application
            workload-type: business
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: default
          requirements:
            - key: "node.kubernetes.io/instance-type"
              operator: In
              values: ["t3.medium", "t3.large",]
            - key: "kubernetes.io/arch"
              operator: In
              values: ["amd64"]
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: ["spot", "on-demand"]
            - key: "topology.kubernetes.io/zone"
              operator: In
              values: ["${local.azs[0]}", "${local.azs[1]}"]
      limits:
        cpu: 16
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 30s
  YAML
  depends_on = [kubectl_manifest.karpenter_node_class]
}
