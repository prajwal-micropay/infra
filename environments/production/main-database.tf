# Database (RDS)
module "database" {
  source = "../../modules/database"

  environment          = "production"
  vpc_id               = module.networking.vpc_id
  private_subnet_a_id  = module.networking.private_subnet_a_id
  private_subnet_b_id  = module.networking.private_subnet_b_id
  create_security_group = true
  db_name              = var.db_name
  db_username          = var.db_username
  db_instance_class    = var.db_instance_class
  skip_final_snapshot  = var.skip_final_snapshot
  multi_az             = var.multi_az

  depends_on = [module.networking]
} 