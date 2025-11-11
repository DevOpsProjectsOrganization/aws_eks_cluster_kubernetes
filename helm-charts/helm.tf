resource "null_resource" "kubeconfig" {
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

resource "helm_release" "external-secrets" {
  depends_on      = [null_resource.kubeconfig]
  name            = "external-secrets"
  repository      = "https://charts.external-secrets.io"
  chart           = "external-secrets"
  create_namespace= true
  namespace       = "tools"
}

resource "null_resource" "external-secret-store"{
  depends_on      = [helm_release.external-secrets]
  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -f - <<EOK
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: tools
data:
  token: ${base64encode(var.vault_token)}
---
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: vault-backend
  namespace: tools
spec:
  provider:
    vault:
      server: "http://vault-internal.sdevops.shop:8200"
      path: "roboshop-dev"
      version: "v2"
      auth:
        tokenSecretRef:
          name: "vault-token"
          key: "token"
          namespace: tools
EOK
EOF
  }
}

# Prometheus stack installation

resource "helm_release" "prometheus" {
  depends_on      = [null_resource.kubeconfig,helm_release.nginx_ingress]
  name            = "kube-prometheus-stack"
  repository      = "oci://ghcr.io/prometheus-community/charts"
  chart           = "kube-prometheus-stack"
  create_namespace= true
  namespace       = "tools"
  values          = [file("${path.module}/helm-values/kube-stack.yml")]
   set_list    {
      name        = "prometheus.ingress.hosts"
      value       = ["prometheus-${var.env}.sdevops.shop"]
    }
}

resource "helm_release" "cluster-autoscaler" {
  depends_on      = [null_resource.kubeconfig, aws_eks_pod_identity_association.cluster-autoscaler]
  name            = "cluster-autoscaler"
  repository      = "https://kubernetes.github.io/autoscaler"
  chart           = "cluster-autoscaler"
  create_namespace= true
  namespace       = "tools"
  values          = [file("${path.module}/helm-values/kube-stack.yml")]
   set    {
      name        = "autoDiscovery.clusterName"
      value       = var.env
    }
    set    {
      name        = "awsRegion"
      value       = "us-east-1"
    }

}

#helm chart for filebeat
resource "helm_release" "filebeat" {
  depends_on      = [null_resource.kubeconfig]
  name            = "filebeat"
  repository      = "https://helm.elastic.co"
  chart           = "filebeat"
  namespace       = "kube-system"
  wait            = false
  values          = [file("${path.module}/helm-values/filebeat.yml")]
}
