resource "kubernetes_namespace" "alertmanager_pro" {
  provider = kubernetes.pro
  metadata {
    name = "alertmanager"
    labels = {
      app = "alertmanager"
    }
  }
}

resource "helm_release" "alertmanager_pro" {
  provider   = helm.pro
  name       = "alertmanager"
  chart      = "path/to/helm/alertmanager"
  namespace  = kubernetes_namespace.alertmanager_pro.metadata[0].name
  values_files = ["./helm/alertmanager/values.yaml"]

  set {
    name  = "alertmanager.vpceSMTPRelay"
    value = "vpce-xxxxxx.vpce-svc-xxxxxx.sa-east-1.vpce.amazonaws.com"
  }

  set {
    name  = "alertSNSForwarder.url"
    value = "vpce-xxxxxx.vpce-svc-xxxxxx.sa-east-1.vpce.amazonaws.com:9087"
  }

  depends_on = [kubernetes_namespace.alertmanager_pro]
}
