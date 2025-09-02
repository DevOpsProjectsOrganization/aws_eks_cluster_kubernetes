databases = {
    mongodb = {
        instance_type = "t2.micro"
    }
    redis= {
        instance_type = "t2.micro"
    }
    mysql = {
        instance_type = "t2.micro"
    }
    rabbitmq = {
        instance_type = "t2.micro"
    }

}

ami     = "ami-00b4d312883eab224"
#"ami-09c813fb71547fc4f"
env     = "dev"
zone_id = "Z08786032W2NWXT9UW4JD"
zone_name= "sdevops.shop"

eks={
    main= {
        
        subnet_ids = [
            "subnet-0b0561e5654e35569", "subnet-0a4f3e69dee139ca9"
            ]
}
    
}
