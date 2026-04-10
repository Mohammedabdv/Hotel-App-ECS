provider "aws" {
  region = var.region
}

module "networking" {
  source            = "../Modules/Networking"
  availability_zone = var.availability_zone
}

module "security" {
  source = "../Modules/Security"
  vpc_id = module.networking.vpc_id
}

module "rds" {
  source             = "../Modules/RDS"
  private_subnet_ids = module.networking.private_subnet_ids
  RDS_SG_id          = module.security.RDS_SG_id
  db_username        = var.db_username
  db_password        = var.db_password
}

module "Application_Load_Balancer" {
  source            = "../Modules/Application_Load_Balancer"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg            = module.security.ALB_SG_id
}

module "IAM_Policy" {
  source     = "../Modules/IAM_Policy"
  secret_arn = module.Secrets_Manager.secret_arn
}

module "ECR" {
  source     = "../Modules/ECR"
}

module "Secrets_Manager" {
  source      = "../Modules/Secrets_Manager"
  app_key     = var.app_key
  db_username = var.db_username
  db_password = var.db_password
}

module "ECS" {
  source                      = "../Modules/ECS"
  ECS_SG_id                   = module.security.ECS_SG_id
  ecs_task_execution_role_arn = module.IAM_Policy.ecs_task_execution_role_arn
  repository_url              = module.ECR.ecr_repository_url
  rds_address                 = module.rds.rds_address
  alb_target_group_arn        = module.Application_Load_Balancer.alb_target_group_arn
  alb_dns_name                = module.Application_Load_Balancer.alb_dns_name
  private_subnet_ids          = module.networking.private_subnet_ids
  secret_arn                  = module.Secrets_Manager.secret_arn

  depends_on = [ module.Application_Load_Balancer ]
}
