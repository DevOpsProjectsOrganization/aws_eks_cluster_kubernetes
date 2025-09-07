module "tools" {
    for_each        = var.tools
    source          = "../modules/ec2"
    ami             = var.ami
    instance_type   =  each.value["instance_type"]
    zone_id         = var.zone_id
    zone_name       = var.zone_name
    name            = each.key
    env             = var.env
}