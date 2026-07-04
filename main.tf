module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "compute" {
  source              = "./modules/compute"
  vpc_id              = module.network.vpc_id
  project_name        = var.project_name
  environment         = var.environment
  public_subnets      = module.network.public_subnets
  private_subnets_web = module.network.private_subnets_web

}

module "database" {
  source                = "./modules/database"
  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  security_group_ec2_sg = module.compute.security_group_ec2_sg
  private_subnets_db    = module.network.private_subnets_db
  db_name               = var.db_name
  db_username           = var.db_username
}
