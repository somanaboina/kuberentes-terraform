output "ebs_csi_driver_role_arn" {
    value = aws_iam_role.ebs-csi-role.arn
}

# output "HELM_EBS_CSI" {
#   value = helm_release.helm-ebs-csi-driver.metadata
# }

output "aws_ebs_driver_arn" {
  value = aws_eks_addon.aws-ebs-csi-driver.arn
}

