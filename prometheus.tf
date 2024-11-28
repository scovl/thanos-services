resource "kubernetes_namespace" "monitoring_pro" {
  provider = kubernetes.pro
  metadata {
    name = "monitoring"
    labels = {
      app = "prometheus"
    }
  }
}

resource "helm_release" "prometheus_pro" {
  provider      = helm.pro
  name          = "prometheus-monitoring"
  chart         = "./helm_charts/prometheus"
  namespace     = kubernetes_namespace.monitoring_pro.metadata[0].name
  values_files  = ["./helm_charts/prometheus/values-pro.yaml"]

  set {
    name  = "account_id"
    value = var.ssm_prefix
  }
  set {
    name  = "region"
    value = "sa-east-1"
  }

  depends_on = [kubernetes_namespace.monitoring_pro]
}
