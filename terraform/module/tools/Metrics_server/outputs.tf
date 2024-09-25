output "helm_metrics_server" {
  value = helm_release.helm-metrics-server-driver.metadata
}
