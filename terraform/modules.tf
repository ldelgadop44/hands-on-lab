module "network" {
    source = "./modules/network"

    aws-region          = var.aws-region
    aws-environment     = var.aws-environment
    project-name        = var.project-name
    subnet-count        = var.subnet-count

}

module "security_groups" {
    source = "./modules/security_groups"

    aws-region          = var.aws-region
    aws-environment     = var.aws-environment
    project-name        = var.project-name
    subnet-count        = var.subnet-count
    vpc_id              = module.network.vpc_id
    authorized-ip       = var.authorized-ip

}

module "kubernetes" {
    source = "./modules/kubernetes"

    aws-environment     = var.aws-environment
    project-name        = var.project-name
    sg-eks-master       = module.security_groups.sg-eks-master
    app_subnet_ids      = module.network.app_subnet_ids
    sg-eks-worker       = module.security_groups.sg-eks-worker
    key-pair-name       = var.key-pair-name
    instance-type       = var.instance-type
    vpc_id              = module.network.vpc_id
    aws_lb_target_group = module.alb.aws_lb_target_group
    sg-eks-alb          = module.security_groups.sg-eks-alb

}

module "alb" {
    source = "./modules/alb"

    aws-environment     = var.aws-environment
    project-name        = var.project-name
    gt_subnet_ids      = module.network.gt_subnet_ids
    sg-eks-worker       = module.security_groups.sg-eks-worker
    vpc_id              = module.network.vpc_id
    sg-eks-alb          = module.security_groups.sg-eks-alb
    
}