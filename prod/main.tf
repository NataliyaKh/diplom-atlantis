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


  # Basic parameters
  cluster_name     = var.cluster_name
  environment      = "prod"
  
  # Versions
  prometheus_stack_version = var.prometheus_stack_version
  
  # Resources
  prometheus_replicas = var.prometheus_replicas
  prometheus_retention = var.prometheus_retention
  
  # Yandex Cloud
  storage_class_name = "standard"
  
  # Secrets
  grafana_admin_password = var.grafana_admin_password
  
  # Monitoring
  enable_alertmanager = true
  enable_thanos       = var.enable_thanos
  
  # Helm values
  extra_values = var.extra_values
}
