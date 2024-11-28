resource "kubernetes_namespace" "loki" {
  provider = kubernetes.pro
  metadata {
    name = "loki"
    labels = {
      app = "loki"
      environment = "production"
    }
  }
}

resource "helm_release" "loki" {
  provider      = helm.pro
  name          = "loki"
  chart         = "grafana/loki"
  namespace     = kubernetes_namespace.loki.metadata[0].name
  repository    = "https://grafana.github.io/helm-charts"
  version       = "5.9.3"
  values_files  = ["./helm_charts/loki/values.yaml"]

  set {
    name  = "loki.config.table_manager.retention_deletes_enabled"
    value = true
  }

  set {
    name  = "loki.config.table_manager.retention_period"
    value = "168h"
  }

  depends_on = [kubernetes_namespace.loki]
}

resource "kubernetes_config_map" "loki_config" {
  metadata {
    name      = "loki-config"
    namespace = kubernetes_namespace.loki.metadata[0].name
  }

  data = {
    loki-config.yaml = <<EOF
auth_enabled: false
server:
  http_listen_port: 3100
common:
  path_prefix: /data/loki
  storage:
    type: s3
    config:
      bucket_name: "loki-logs-bucket"
      region: "sa-east-1"
schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: s3
      schema: v11
      index:
        prefix: loki_index_
        period: 168h
storage_config:
  aws:
    s3: s3://loki-logs-bucket
  boltdb_shipper:
    active_index_directory: /data/loki/boltdb-shipper-active
    shared_store: s3
    cache_location: /data/loki/boltdb-shipper-cache
EOF
  }
}
