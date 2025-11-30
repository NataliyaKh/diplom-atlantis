# StorageClass
resource "kubernetes_storage_class_v1" "cluster_storage" {
  metadata {
    name = "standard"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
}

# Install Nginx Ingress Controller
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  force_update  = true
  recreate_pods = true

  # hostPort
  set {
    name  = "controller.hostPort.enabled"
    value = "true"
  }

  set {
    name  = "controller.hostPort.ports.http"
    value = "80"
  }

  set {
    name  = "controller.hostPort.ports.https"
    value = "443"
  }

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "controller.nodeSelector.kubernetes\\.io/hostname"
    value = "master"
  }

  set {
    name  = "controller.tolerations[0].key"
    value = "node-role.kubernetes.io/control-plane"
  }

  set {
    name  = "controller.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "controller.tolerations[0].effect"
    value = "NoSchedule"
  }

  depends_on = [kubernetes_storage_class_v1.cluster_storage]
}

resource "time_sleep" "wait_for_ingress" {
  depends_on = [helm_release.ingress_nginx]
  create_duration = "60s"
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

  depends_on = [time_sleep.wait_for_ingress,
#  kubernetes_network_policy_v1.allow_ingress["monitoring"]
  ]
}
