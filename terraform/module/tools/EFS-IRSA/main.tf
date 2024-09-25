# Getting the policy (JSON) content - took from documentation
data "http" "efs-csi-policy-json" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "efs-csi-policy" {
  name        = "${var.role_efs_csi_driver}-policy"
  path        = "/"
  description = "This policy will give enough permisson to IRSA so that it can talk to EFS"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  depends_on = [ data.http.efs-csi-policy-json ]
  policy = data.http.efs-csi-policy-json.response_body
}

resource "aws_iam_role" "efs-csi-role" {
  name = var.role_efs_csi_driver

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : var.eks_oidc_connect_provider_arn
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${var.eks_oidc_connect_provider_arn_extract}:sub" : "system:serviceaccount:${var.efs_csi_driver_namespace}:${var.efs_csi_driver_sa_name}"
            }
          }
        }
      ]
    }
  )

  tags = {
    Name = var.cluster_id
    env  = var.ENV
  }
}

resource "aws_iam_role_policy_attachment" "efs-csi-policy-attachment" {
  role       = aws_iam_role.efs-csi-role.name
  policy_arn = aws_iam_policy.efs-csi-policy.arn
}

/*

There are 2 Ways to Deploy Driver

# 🔸 Helm
# 🔸 EKS Add-ons

*/

# 🔸 Helm
# Lets install EBS CSI Driver through HELM provider
/*
resource "helm_release" "helm-efs-csi-driver" {
  depends_on = [ aws_iam_role_policy_attachment.efs-csi-policy-attachment  ]
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  namespace  = var.EFS_CSI_DRIVER_NAMESPACE

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-efs-csi-driver"
  }
  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "controller.serviceAccount.name"
    value = var.EFS_CSI_DRIVER_SA_NAME
  }
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.efs-csi-role.arn}"
    # value = aws_iam_role.ebs-csi-role.arn
  }
}

*/



# 🔸 EKS Add-ons
# Lets install EFS CSI Driver through AWS provider
resource "aws_eks_addon" "aws-efs-csi-driver" {
  cluster_name = var.cluster_id
  addon_name   = "aws-efs-csi-driver"
  service_account_role_arn  = "${aws_iam_role.efs-csi-role.arn}"
}

