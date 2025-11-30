# Yandex Cloud
variable "yandex_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  sensitive   = true
}

variable "yandex_folder_id" {
  type        = string
  description = "Yandex Folder ID"
  sensitive   = true
}

variable "yandex_zone" {
  type        = string
  description = "Yandex Cloud zone"
  default     = "ru-central1-a"
}

# Cluster
variable "cluster_name" {
  type    = string
  default = "production-k8s"
}

# Versions
variable "prometheus_stack_version" {
  type    = string
  default = "51.7.1"
}

# Resources
variable "prometheus_replicas" {
  type    = number
  default = 2
}

variable "prometheus_retention" {
  type    = string
  default = "30d"
}

variable "enable_thanos" {
  type    = bool
  default = true
}

variable "storage_class_name" {
  type    = string
  default = "standard"
}

variable "load_balancer_annotations" {
  type    = map(string)
  default = {
    "yandex.cloud/load-balancer-type" = "external"
  }
}

variable "extra_values" {
  type    = map(any)
  default = {}
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}
