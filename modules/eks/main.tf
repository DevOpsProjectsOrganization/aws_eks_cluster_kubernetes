resource "aws_eks_cluster" "main-cluster" {
  name = "${var.env}"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = var.subnet_ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  ]
}

resource "aws_eks_node_group" "nodegroup_1" {
  cluster_name    = aws_eks_cluster.main-cluster.name
  node_group_name = "nodegroup_1"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      =  [
     "subnet-0a4f3e69dee139ca9", "subnet-0b0561e5654e35569"
    ]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  
}
resource "aws_eks_addon" "example" {
  cluster_name = aws_eks_cluster.main-cluster.name
  addon_name   = "vpc-cni"
  configuration_values= jsonencode( {
    "enableNetworkPolicy": "true",
    "nodeAgent": {
        "enablePolicyEventLogs" : "true"
    }
})
}