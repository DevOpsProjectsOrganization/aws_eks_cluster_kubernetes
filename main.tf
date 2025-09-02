module "ec2" {
    for_each        = var.databases
    source          = "./modules/ec2"
    ami             = var.ami
    instance_type   =  each.value["instance_type"]
    zone_id         = var.zone_id
    zone_name       = var.zone_name
    name            = each.key
    env             = var.env
}
module "eks" {
    source          = "./modules/eks"
    for_each        = var.eks
    version         = each.value["version"]
    subnet_ids      = each.value["subnet_ids"]
    env             = var.env

}
