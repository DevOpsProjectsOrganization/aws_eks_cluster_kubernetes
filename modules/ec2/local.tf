locals {         
  iam_policy = concat(["sts:GetCallerIdentity","ecr:GetDownloadUrlForLayer","ecr:GetAuthorizationToken","ecr:BatchGetImage"], var.iam_policy)
}