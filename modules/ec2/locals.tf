locals {
name = var.env==null ? var.name :"${var.name}-${var.env}"
toolName= var.env==null ?  "${var.name}-internal" : "${var.name}-${var.env}" 
toolPublicName= var.env==null ?   var.name : "${var.name}-${var.env}" 
}