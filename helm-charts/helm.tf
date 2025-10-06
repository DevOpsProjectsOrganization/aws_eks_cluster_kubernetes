resource "null_resource" "kubeconfig"{
  triggers = {
    always = timestamp()
  } 
 depends_on  = [module.eks]
provisioner "local-exec"{
     command = <<EOF        
       aws eks update-kubeconfig --name ${var.env} --region us-east-1
       echo "success"
     EOF
 }
}
# this nginx ingress controller comes on top of load balancer and argoCD 
resource "helm_release" "nginx_ingress" {
  depends_on = [data.aws_eks_cluster.eks]
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = true
}