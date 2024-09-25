resource "helm_release" "helm-metrics-server-driver" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = var.metrics_server_driver_namespace
  version    = "3.12.0"
  set {
    name  = "serviceAccount.name"
    value = var.metrics_server_driver_sa_name
  }
}

