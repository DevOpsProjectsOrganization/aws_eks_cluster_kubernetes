data "aws_eks_cluster" "main-cluster" {
  name = aws_eks_cluster.main-cluster.name
}

data "aws_eks_cluster_auth" "main-cluster" {
  name = aws_eks_cluster.main-cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main-cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main-cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main-cluster.token
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on        = [aws_eks_cluster.main-cluster]
  name              = "nginx-ingress-controller"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  create_namespace  = true
  namespace         = "ingress-nginx"
}
