resource "kubernetes_namespace" "yace_metrics" {
  metadata {
    name = "yace-metrics"
    labels = {
      app = "yace"
    }
  }
}

resource "kubernetes_service_account" "yace_metrics" {
  metadata {
    name      = "yace-role"
    namespace = kubernetes_namespace.yace_metrics.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::1234567890:role/custom-metrics-EksWorkerNode-role"
    }
  }
}

resource "helm_release" "yace_metrics" {
  for_each = {
    for key, value in var.consumers : key => value if value.yace_active
  }

  name         = "yace-metrics-${each.key}"
  chart        = "${path.module}/yace_chart"
  namespace    = kubernetes_namespace.yace_metrics.metadata[0].name
  values_files = [
    each.value["values"],
    file("${path.module}/yace_chart/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.yace_metrics,
    kubernetes_service_account.yace_metrics
  ]
}
