# Grafana
resource "kubernetes_persistent_volume_v1" "grafana" {
  metadata {
    name = "grafana-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }
    
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "standard"
    
    persistent_volume_source {
      host_path {
        path = "/mnt/grafana"
        type = "DirectoryOrCreate"
      }
    }
  }
}

# Prometheus
resource "kubernetes_persistent_volume_v1" "prometheus" {
  metadata {
    name = "prometheus-pv"
  }

  spec {
    capacity = {
      storage = "20Gi"
    }
    
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "standard"
    
    persistent_volume_source {
      host_path {
        path = "/mnt/prometheus"
        type = "DirectoryOrCreate"
      }
    }
  }
}

# Alertmanager
resource "kubernetes_persistent_volume_v1" "alertmanager" {
  metadata {
    name = "alertmanager-pv"
  }

  spec {
    capacity = {
      storage = "2Gi"
    }
    
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "standard"
    
    persistent_volume_source {
      host_path {
        path = "/mnt/alertmanager"
        type = "DirectoryOrCreate"
      }
    }
  }
}
