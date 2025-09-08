ami     = "ami-00b4d312883eab224"
env     = "tool"
zone_id = "Z08786032W2NWXT9UW4JD"
zone_name= "sdevops.shop"
tools = {
    github-runner={
        instance_type = "t2.micro"
        iam_policy    = ["*"]
    }
}