resource "null_resource" "kubeconfig" {
  depends_on = [aws_eks_cluster.main-cluster]
  triggers   = {
    always    = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOF
      aws eks update-kubeconfig --name ${var.env}
    EOF
  }

}

resource "helm_release" "nginx_ingress" {
  depends_on        = [null_resource.kubeconfig]
  name              = "nginx-ingress-controller"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  create_namespace  = true
  namespace         = "tools"
  values            = [file("${path.module}/helm-values/ingress.yml")]
}

resource "helm_release" "external-dns" {
  depends_on        = [null_resource.kubeconfig]
  name              = "external-dns"
  repository        = "https://kubernetes-sigs.github.io/external-dns/"
  chart             = "external-dns"
  create_namespace  = true
  namespace         = "tools"
}

resource "helm_release" "argocd" {
  depends_on      = [null_resource.kubeconfig, helm_release.nginx_ingress ]
  name            = "argo-cd"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  create_namespace= true
  namespace       = "tools"
  values            = [file("${path.module}/helm-values/argo.yml")]
  set    {
      name        = "global.domain"
      value       = "argocd-${var.env}.sdevops.shop"
    }
}
