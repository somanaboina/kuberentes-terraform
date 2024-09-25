output "efs_csi_driver_role_arn" {
    value = aws_iam_role.efs-csi-role.arn
}

# output "HELM_EFS_CSI" {
#   value = helm_release.helm-efs-csi-driver.metadata
# }

output "aws_efs_csi_driver_arn" {
  value = aws_eks_addon.aws-efs-csi-driver.arn
}

