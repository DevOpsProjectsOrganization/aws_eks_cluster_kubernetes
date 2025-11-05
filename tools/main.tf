module "tools" {
    for_each        = var.tools
    source          = "../modules/ec2"
    ami             = var.ami
    instance_type   =  each.value["instance_type"]
    zone_id         = var.zone_id
    zone_name       = var.zone_name
    name            = each.key
    iam_policy      = try(each.value["iam_policy"], [])
    env             = var.env
    spot            = try(each.value["spot"], false)
    spot_max_price  = try(each.value["spot_max_price"], 0)
}

resource "aws_ecr_repository" "main" {
   for_each            = var.ecr
    name                = each.key
   image_tag_mutability= each.value
}