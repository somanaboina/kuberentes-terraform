resource "aws_iam_role" "container-insight-role" {
  name = var.role_container_insight_driver

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
              "${var.eks_oidc_connect_provider_arn_extract}:aud" : "sts.amazonaws.com",
              "${var.eks_oidc_connect_provider_arn_extract}:sub" : "system:serviceaccount:${var.container_insight_driver_namespace}:${var.container_insight_driver_sa_name}"
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

resource "aws_iam_role_policy_attachment" "container-insight-policy-attachment-01" {
  role       = aws_iam_role.container-insight-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "container-insight-policy-attachment-02" {
  role       = aws_iam_role.container-insight-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess" // Taken from AWS Doc - List of EKS-Add-on
}


resource "aws_eks_addon" "aws-container-insight-driver" {
  cluster_name = var.cluster_id
  addon_name   = "amazon-cloudwatch-observability"
  service_account_role_arn  = "${aws_iam_role.container-insight-role.arn}"
}

