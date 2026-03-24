module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "cognito" {
  source               = "./modules/cognito"
  project_name         = var.project_name
  aws_region           = var.aws_region
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
}

module "compute" {
  source       = "./modules/compute"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  subnet_id    = module.networking.subnet_id
  key_name     = var.key_name
}
