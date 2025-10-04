resource "aws_eks_cluster" "main-cluster" {
  name = "${var.env}"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"
  #creates an opening for any outer nodes accessing the cluster
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  #depends_on = [
   # aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  #]
}

resource "aws_eks_node_group" "nodegroup_1" {
  cluster_name    = aws_eks_cluster.main-cluster.name
  node_group_name = "nodegroup_1"
  node_role_arn   = aws_iam_role.node.arn
  instance_types  = t3.xlarge
  subnet_ids      =  [
     "subnet-0a4f3e69dee139ca9", "subnet-0b0561e5654e35569"
    ]

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 3
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
#create a access point for the cluster 
resource "aws_eks_access_entry" "access" {
  for_each          = var.access
  cluster_name      = aws_eks_cluster.main-cluster.name
  principal_arn     = each.value["principal_arn"]
  kubernetes_groups =  try(each.value["kubernetes_groups"],[])
  type              = "STANDARD"
}
# now the access point and the cluster entry point are connected
resource "aws_eks_access_policy_association" "main" {
  for_each      = var.access
  cluster_name  = aws_eks_cluster.main-cluster.name
  policy_arn    = each.value["policy_arn"]
  principal_arn = each.value["principal_arn"]

  access_scope {
    type       = each.value["access_scope"]
    namespaces = each.value["access_scope"] == "cluster" ? [] : try(each.value["namespaces"], [])
  }
}