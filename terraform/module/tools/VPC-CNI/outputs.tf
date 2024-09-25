output "vpc_cni_role_arn" {
    value = aws_iam_role.vpc-cni-role.arn
}

output "vpc_cni_arn" {
  value = aws_eks_addon.aws-vpc-cni-addon.arn
}
