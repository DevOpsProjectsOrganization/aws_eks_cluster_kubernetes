variable "databases" {}
variable "env" {}
variable "zone_id" {}
variable "zone_name" {}
variable "ami" {}
variable "eks" {
    subnet_ids = [
            "subnet-0b0561e5654e35569", "subnet-0a4f3e69dee139ca9"
            ]
        env        = "dev"
        access = {
            workstation = {
                principal_arn   = "arn:aws:iam::533567530972:role/workstation_role"
                policy_arn      = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
                access_scope    = "cluster"
            }
            github-runner = {
                principal_arn = "arn:aws:iam::533567530972:role/github-runner-tool-role"
                access_scope  = "cluster"
                policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            }
        }
      
}
