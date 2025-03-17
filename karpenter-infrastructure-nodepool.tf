# NodePool para infraestructura (Istio, ArgoCD, etc.)
resource "kubectl_manifest" "karpenter_infra_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: infrastructure
    spec:
      template:
        metadata:
          labels:
            node-type: infrastructure
            workload-type: platform
        spec:
          taints:
            - key: "workload-type"
              value: "infrastructure"
              effect: PreferNoSchedule
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: default
          requirements:
            - key: "node.kubernetes.io/instance-type"
              operator: In
              values: ["t3.medium", "t3.large", "t3.xlarge"]
            - key: "kubernetes.io/arch"
              operator: In
              values: ["amd64"]
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: ["on-demand"]
            - key: "topology.kubernetes.io/zone"
              operator: In
              values: ["${local.azs[0]}", "${local.azs[1]}"]
      limits:
        cpu: 8
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 30s
  YAML
  depends_on = [kubectl_manifest.karpenter_node_class]
}
