output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_id" {
  value = aws_eks_cluster.main.id
}