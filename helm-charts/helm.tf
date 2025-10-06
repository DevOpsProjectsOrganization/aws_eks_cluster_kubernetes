resource "null_resource" "kubeconfig"{
    depends_on  = [aws_eks_cluster.main-cluster]
    provisioner "local-exec"{
        command = <<EOF 
        aws eks describe-cluster --name dev --region us-east-1       
        aws eks update-kubeconfig --name ${aws_eks_cluster.main-cluster.name} --region us-east-1
        echo "success"
        EOF
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