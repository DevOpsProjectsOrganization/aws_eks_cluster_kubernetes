resource "null_resource" "kubeconfig" {

  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
      aws eks update-kubeconfig --name ${var.env}
      #kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    EOF
  }

}

resource "helm_release" "nginx_ingress" {
  depends_on        = [null_resource.kubeconfig]
  name              = "nginx-ingress-controller"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  create_namespace  = true
  namespace         = "ingress-nginx"
}
