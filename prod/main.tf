# StorageClass
data "kubernetes_storage_class_v1" "existing_standard" {
  metadata {
    name = "standard"
  }
}

locals {
  storage_class_exists = can(data.kubernetes_storage_class_v1.existing_standard.metadata[0].name)
}

resource "kubernetes_storage_class_v1" "cluster_storage" {
  count = local.storage_class_exists ? 0 : 1

  metadata {
    name = "standard"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
}

module "kube_prometheus" {
  source = "../modules/kube-prometheus"

  # Basic parameters
  cluster_name     = var.cluster_name
  environment      = "prod"

  # Versions
  prometheus_stack_version = var.prometheus_stack_version

  # Storage class for PVC in Prometheus stack
  storage_class_name = "standard"
}

# Output
output "storage_class_info" {
  value = local.storage_class_exists ? "StorageClass 'standard' уже существует в кластере" : "StorageClass 'standard' будет создан"
}
