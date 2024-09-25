output "external_dns_role_arn" {
    value = aws_iam_role.externalDNS-role.arn
}

output "helm_externalDNS" {
  value = helm_release.helm-externalDNS.metadata
}

