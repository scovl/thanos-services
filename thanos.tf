resource "kubernetes_namespace" "thanos_namespace" {
  for_each = var.consumers
  metadata {
    name = "thanos-${each.key}"
    labels = {
      app = "thanos"
    }
  }
}

resource "helm_release" "thanos_metrics" {
  for_each = {
    for key, value in var.consumers : key => value if value.prometheus_active
  }

  name         = "thanos-${each.key}"
  chart        = "${path.module}/thanos_chart"
  namespace    = "thanos-${each.key}"
  values_files = [
    each.value["values"],
    file("${path.module}/thanos_chart/values-default.yaml")
  ]

  depends_on = [kubernetes_namespace.thanos_namespace]
}
