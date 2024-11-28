resource "kubernetes_namespace" "grafana" {
  provider = kubernetes.pro
  metadata {
    name = "grafana"
    labels = {
      app = "grafana"
      environment = "production"
    }
  }
}

resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  data = {
    "datasources.yaml" = <<EOF
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki.loki:3100
    isDefault: true
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus.monitoring:9090
EOF
  }
}

resource "helm_release" "grafana" {
  provider     = helm.pro
  name         = "grafana"
  chart        = "grafana/grafana"
  namespace    = kubernetes_namespace.grafana.metadata[0].name
  repository   = "https://grafana.github.io/helm-charts"
  values_files = ["${path.module}/helm_charts/grafana/values.yaml"]

    set_sensitive {
    name  = "adminPassword"
    value = data.aws_ssm_parameter.grafana_admin_password.value
    }
}

