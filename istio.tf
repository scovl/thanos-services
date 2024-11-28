resource "kubernetes_namespace" "istio_system_pro" {
  provider = kubernetes.pro
  metadata {
    name = "istio-system"
    labels = {
      app = "istio"
    }
  }
}

resource "helm_release" "istio_base_pro" {
  provider      = helm.pro
  name          = "istio-ingress"
  chart         = "./helm/istio/base"
  namespace     = kubernetes_namespace.istio_system_pro.metadata[0].name
  values_files  = ["./helm/istio/base/values.yaml"]
  depends_on    = [kubernetes_namespace.istio_system_pro]
}

resource "helm_release" "istiod_pro" {
  provider      = helm.pro
  name          = "istiod"
  chart         = "./helm/istio/istio-control/istio-discovery"
  namespace     = kubernetes_namespace.istio_system_pro.metadata[0].name
  values_files  = ["./helm/istio/istio-control/istio-discovery/values.yaml"]
  depends_on    = [kubernetes_namespace.istio_system_pro]
}
