resource "aws_instance" "my_instance" {
    count                   = var.spot ? 0 : 1
    ami                     = var.ami
    instance_type           =  var.instance_type
    vpc_security_group_ids  = [data.aws_security_group.selected.id]
    iam_instance_profile    = aws_iam_instance_profile.main.name
    tags                    = {
        Name        = local.name
        monitor     = "true"
    }
    root_block_device {
        volume_size = 90 
        volume_type = "gp3"
    }
}

resource "aws_instance" "spot_instance" {
    count                   = var.spot ? 1 : 0
    ami                     = var.ami
    instance_type           = var.instance_type
    vpc_security_group_ids  = [data.aws_security_group.selected.id]
    iam_instance_profile    = aws_iam_instance_profile.main.name
    tags                    = {
        Name        = local.name
        monitor     = "true"
    }
    root_block_device {
        volume_size = 30 
    }
    instance_market_options {
        market_type = "spot"
        spot_options {
            max_price                       = var.spot_max_price
            instance_interruption_behavior  = "stop"
            spot_instance_type              = "persistent"
    }
  }
}

resource "aws_route53_record" "my_private_record"{
    zone_id = var.zone_id
    name    = local.toolName
    type    = "A"
    ttl     = 300
    records = var.spot ? [aws_instance.spot_instance[0].private_ip] :[aws_instance.my_instance[0].private_ip]
}

resource "aws_route53_record" "my_public_record"{
    count   = var.env==null ? 1 :0
    zone_id = var.zone_id
    name    = local.toolPublicName
    type    = "A"
    ttl     = 300
    records = var.spot ? [aws_instance.spot_instance[0].public_ip] :[aws_instance.my_instance[0].public_ip]
}

resource "null_resource" "ansible"{
    #triggers= {
    #   always = var.env==null ? timestamp() :"false"
    #}
    count = var.env == null ?0 :1
   
    depends_on = [
        aws_route53_record.my_private_record, 
        aws_instance.my_instance]
    provisioner "remote-exec"{
         connection {
            type     = "ssh"
            user     = "ec2-user"
            password = "DevOps321"
            host     = var.spot ? aws_instance.spot_instance[0].private_ip : aws_instance.my_instance[0].private_ip
        }
        inline = [
            "ansible-pull -i localhost, -U https://github.com/DevOpsProjectsOrganization/ecommerce_ansible roboshop.yml -e env=${var.env} -e role=${var.name} | sudo tee /opt/ansible.log"
        ]
       
    }
}