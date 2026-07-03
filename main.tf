module "network" {
  source = "./modules/network"

  aws_region         = var.aws_region
  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  #public_subnets      = var.public_subnets
  #private_subnets_web = var.private_subnets_web
}

module "compute" {
  source              = "./modules/compute"
  vpc_id              = module.network.vpc_id
  aws_region          = var.aws_region
  project_name        = var.project_name
  environment         = var.environment
  public_subnets      = module.network.public_subnets
  private_subnets_web = module.network.private_subnets_web

}
