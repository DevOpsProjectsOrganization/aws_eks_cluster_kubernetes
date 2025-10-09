data "aws_eks_cluster" "main-cluster" {
  name = aws_eks_cluster.main-cluster.name
}

data "aws_eks_cluster_auth" "main-cluster" {
  name = aws_eks_cluster.main-cluster.name
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.main-cluster.endpoint
    cluster_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJS1RmQUs4RXNlUWN3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRFd01EWXdOalV5TlRsYUZ3MHpOVEV3TURRd05qVTNOVGxhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM0d2NGdjZiZk91NzJLMEFCeGhhdmZaRGtsTUFXNFJZV2NrUnZCWE1aUlgrdXZpNHVvbFhDaXJ5MTEKQzQ3ZGxobmtSQUJNZkNaNEhPcElEWmNmbkF0OWFGY3ZhOFRCMkR0S1lSeHBqY3RhTXJkSXBRWWdUNjEzdUorVQp1VmhQWEFSVEpsRStIdjlUV0xUL1c3RFpmNVB3VnIyMnZtNHRKTnhrbU1PVmFHbmZPZXJFM1dESGF2MmhsZ3NuCkxZdjlPcHUxcFA2WVFwdjNYNkkzcmVxYnZKQzBNdkVRc3J0eis4MEJpOEt5RWJzVld0NHhaT3BmQkU5V2N5VDkKTXlZaXNjNlF1TjRVUnpZeVM4K2dUd0p2UzU0UWg5MzVHUC84endmYnh1T05rN2tab253cDMwaFJ0djEyNkZVQwpGa2s1dEoyRGRQVFZ1QUh0WUZjMzhudktZdm1GQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUbDB3d01yTUZRczk0ZHhvaE80c2x4RnQ1czlEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQUpVRGZqSkZSMgpTNUIzSkR2d1poaUMwMkZLbmdGTU9wRmd4eU4rUTZUOFRtZnFiZDcvcUpiZFdTQTdBaHZGOFBjR0cycUdmTGN2ClVSZE9EMk9rbzZZQ09XNVVtSXRQRytEc1RKTlg2ZEJHUDFYa255TnpPeEdQM2VLc0xFZDRwc3p5YjJXaXBmZmwKRGZzTkZ5bkJlYmIxR3FGV1J5L3djVmZqTzhUN3VrZzhmWkk4QkwvTmF4cDlPV1Q0YnhMa29qVVZLbEl6YXdKQwpjdmxvNGNFUnQ2RllyNnkzZFcwaGFrckQyRU5KL082VTVvbWlnUUFrck93Wld4TjdHdmcweXVTVjlqMHEzb0c3CnBzSXlaTU9TZTdnS3JlMlBCYk94NU1VWWl3WUtveE8remFWTnVMSS84K2VadEdMcjRBMFljckZYWnRWdWN6RloKb2Ywa2ZBV1ZHaTd3Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
    token                  = data.aws_eks_cluster_auth.main-cluster.token
}

resource "helm_release" "nginx_ingress" {
  depends_on        = [aws_eks_cluster.main-cluster]
  name              = "nginx-ingress-controller"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  create_namespace  = true
  namespace         = "ingress-nginx"
}
