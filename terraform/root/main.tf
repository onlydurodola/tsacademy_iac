module "core" {
  source = "../modules/core"

  project_name = var.project_name
  aws_region   = var.aws_region
  azs          = var.azs
}

module "vpc" {
  source = "../modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

}

module "ec2" {
  source = "../modules/ec2"

  project_name         = var.project_name
  frontend_subnet_id   = module.vpc.public_subnet_ids[0]
  backend_subnet_id    = module.vpc.public_subnet_ids[0]
  frontend_sg_id       = module.vpc.frontend_sg_id
  backend_sg_id        = module.vpc.backend_sg_id
  ssh_key_name         = var.ssh_key_name
}

module "rds" {
  source = "../modules/rds"

  project_name        = var.project_name
  private_subnet_ids  = module.vpc.private_subnet_ids
  database_sg_id      = module.vpc.database_sg_id

  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
}
