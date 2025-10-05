resource "null_resource" "kubeconfig"{
    depends_on  = [
      aws_eks_cluster.main-cluster,
      aws_eks_node_group.nodegroup
      ]
    provisioner "local-exec"{
        command = <<EOT
          aws eks wait cluster-active --name ${var.env}
          aws eks update-kubeconfig --name ${var.env} --region us-east-1
        EOT
    }
}
# this nginx ingress controller comes on top of load balancer and argoCD 
resource "helm_release" "nginx_ingress" {
  depends_on = [null_resource.kubeconfig]
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx" 
}