output "container_insight_driver_arn" {
    value = aws_iam_role.container-insight-role.arn
}

output "aws_container_insight_driver_arn" {
  value = aws_eks_addon.aws-container-insight-driver.arn
}

