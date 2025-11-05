ami     = "ami-00b4d312883eab224"
env     = null
zone_id = "Z08786032W2NWXT9UW4JD"
zone_name= "sdevops.shop"
tools = {
    github-runner={
        instance_type = "t2.micro"
      iam_policy    = ["eks:DescribeCluster","eks:ListClusters","eks:ListFargateProfiles","eks:ListNodegroups","*"]
    }
    vault = {
        instance_type = "t3.small"
    }
    elk = {
        instance_type = "m8i.xlarge"
        spot          = true
        spot_max_price= 0.19
    }
}
ecr = {
    frontend    =   "IMMUTABLE"
    cart        =   "IMMUTABLE"
    catalogue   =   "IMMUTABLE"
    payment     =   "IMMUTABLE"
    user        =   "IMMUTABLE"
    shipping    =   "IMMUTABLE"
    runner      =   "MUTABLE"
}
