output "lbc_role_arn" {
    value = aws_iam_role.lbc-role.arn
}

output "helm_lbc" {
  value = helm_release.helm-lbc-controller.metadata
}

