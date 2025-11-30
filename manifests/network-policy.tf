resource "kubernetes_network_policy_v1" "allow_ingress" {
  for_each = toset(["monitoring", "diplom-nginx-namespace"])

  metadata {
    name      = "allow-ingress"
    namespace = each.key
  }

  spec {
    pod_selector {}

    policy_types = ["Ingress"]

    ingress {
      from {
        ip_block {
          cidr = "10.0.0.0/16"
        }
      }
    }
    
    ingress {
      from {
        namespace_selector {}
      }
    }
  }

  dynamic "depends_on" {
    for_each = each.key == "monitoring" ? [1] : []
    content {
      module.kube_prometheus
    }
  }
}
