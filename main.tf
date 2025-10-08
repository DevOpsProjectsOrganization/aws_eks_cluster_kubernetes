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
    subnet_ids      = var.eks["subnet_ids"]
    env             = var.eks["env"]
    access          = var.eks["access"]
}

