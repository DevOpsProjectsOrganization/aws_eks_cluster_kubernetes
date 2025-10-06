resource "null_resource" "kubeconfig" {
  depends_on = [aws_eks_cluster.main-cluster]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.main-cluster.name} "
  }
}
# this nginx ingress controller comes on top of load balancer and argoCD 
resource "helm_release" "nginx_ingress" {
  depends_on = [null_resource.kubeconfig]
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = true
}