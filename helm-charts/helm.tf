#resource "null_resource" "kubeconfig"{
# depends_on  = [
#   aws_eks_cluster.main-cluster,
#   aws_eks_node_group.nodegroup,
#   aws_eks_addon.example,
#   aws_eks_access_entry.access,
#    aws_eks_access_policy_association.main
#   ]
# provisioner "local-exec"{
#     command = <<EOT
        
#       aws eks update-kubeconfig --name ${var.env} --region us-east-1
#       kubectl get svc || true
#     EOT
# }
#}
# this nginx ingress controller comes on top of load balancer and argoCD 
#resource "helm_release" "nginx_ingress" { 
# depends_on = [null_resource.kubeconfig]
# name       = "nginx-ingress-controller"
# repository = "https://kubernetes.github.io/ingress-nginx"
#  chart      = "ingress-nginx" 
#}

resource "null_resource" "execute_command" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks get-token \
        --cluster-name ${var.env} \
        --region us-east-1  > eks_token.txt
    EOT
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "cat"
    args        = ["eks_token.txt"]
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on = [
    aws_eks_cluster.main-cluster,
    aws_eks_node_group.nodegroup,
    aws_eks_addon.example,
    aws_eks_access_entry.access,
    aws_eks_access_policy_association.main
  ]
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = true
}