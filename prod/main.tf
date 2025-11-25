# StorageClass
resource "kubernetes_storage_class_v1" "cluster_storage" {
  metadata {
    name = "standard"
  }
  
  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
}


module "kube_prometheus" {
  source = "../modules/kube-prometheus"

  cluster_name     = var.cluster_name
  environment      = "prod"
  
  prometheus_stack_version = var.prometheus_stack_version
  
  prometheus_replicas = var.prometheus_replicas
  prometheus_retention = var.prometheus_retention
  
  storage_class_name = "standard"
  
  grafana_admin_password = var.grafana_admin_password
  
  enable_alertmanager = true
  enable_thanos       = var.enable_thanos
  
  extra_values = var.extra_values
}
