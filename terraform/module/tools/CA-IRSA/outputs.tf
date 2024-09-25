output "cluster_autoscalar_role_arn" {
    value = aws_iam_role.clusterAutoscalar-role.arn
}

output "helm_cluster_autoscalar" {
  value = helm_release.helm-clusterAutoscalar-driver.metadata
}

