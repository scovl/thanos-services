resource "kubernetes_horizontal_pod_autoscaler_v2" "grafana" {
  provider   = kubernetes.pro
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "grafana"
    }
    min_replicas = var.hpa_min_replicas
    max_replicas = var.hpa_max_replicas
    metrics {
      type = "Resource"
      resource {
        name  = "cpu"
        target {
          type               = "Utilization"
          average_utilization = var.hpa_cpu_utilization
        }
      }
    }
    metrics {
      type = "Resource"
      resource {
        name  = "memory"
        target {
          type               = "Utilization"
          average_utilization = var.hpa_memory_utilization
        }
      }
    }
  }
}


resource "kubernetes_horizontal_pod_autoscaler_v2" "loki" {
  provider   = kubernetes.pro
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.loki.metadata[0].name
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "loki"
    }
    min_replicas = 2
    max_replicas = 10
    metrics {
      type = "Resource"
      resource {
        name  = "cpu"
        target {
          type    = "Utilization"
          average_utilization = 85
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "prometheus" {
  provider   = kubernetes.pro
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring_pro.metadata[0].name
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "prometheus"
    }
    min_replicas = 1
    max_replicas = 5
    metrics {
      type = "Resource"
      resource {
        name  = "cpu"
        target {
          type    = "Utilization"
          average_utilization = 70
        }
      }
    }
    metrics {
      type = "Resource"
      resource {
        name  = "memory"
        target {
          type    = "Utilization"
          average_utilization = 65
        }
      }
    }
  }
}
