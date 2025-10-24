## Roles for Pods in kubernetes 
resource "aws_iam_role" "external-dns" {
  name = "${var.env}-pod-external-dns-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "external-dns"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["route53:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_eks_pod_identity_association" "external-dns" {
  depends_on      = [aws_iam_role.external, null_resource.kubeconfig]
  cluster_name    = var.env
  namespace       = "tools"
  service_account = "external-dns"
  role_arn        = aws_iam_role.external-dns.arn
}