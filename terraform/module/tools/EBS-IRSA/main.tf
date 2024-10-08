# Getting the policy (JSON) content - took from documentation
data "http" "ebs-csi-policy-json" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}


resource "aws_iam_policy" "ebs-csi-policy" {
  name        = "${var.role_ebs_csi_driver}-policy"
  path        = "/"
  description = "This policy will give enough permisson to IRSA so that it can talk to EBS"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  depends_on = [ data.http.ebs-csi-policy-json ]
  policy = data.http.ebs-csi-policy-json.response_body
}


resource "aws_iam_role" "ebs-csi-role" {
  name = var.role_ebs_csi_driver

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
              "${var.eks_oidc_connect_provider_arn_extract}:sub" : "system:serviceaccount:${var.ebs_csi_driver_namespace}:${var.ebs_csi_driver_sa_name}"
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

resource "aws_iam_role_policy_attachment" "ebs-csi-policy-attachment" {
  role       = aws_iam_role.ebs-csi-role.name
  policy_arn = aws_iam_policy.ebs-csi-policy.arn
}

/*

There are 2 Ways to Deploy Driver

# 🔸 Helm
# 🔸 EKS Add-ons

*/

# 🔸 Helm
# Lets install EBS CSI Driver through helm provider
/*
resource "helm_release" "helm-ebs-csi-driver" {
  depends_on = [ aws_iam_role_policy_attachment.ebs-csi-policy-attachment  ]
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = var.EBS_CSI_DRIVER_NAMESPACE

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "controller.serviceAccount.name"
    value = var.EBS_CSI_DRIVER_SA_NAME
  }
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.ebs-csi-role.arn}"
    # value = aws_iam_role.ebs-csi-role.arn
  }
}

*/

# 🔸 EKS Add-ons
# Lets install EBS CSI Driver through AWS provider

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = var.cluster_id
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn  = "${aws_iam_role.ebs-csi-role.arn}"
}

