# Compute resources (EC2, ALB, ASG)
module "compute" {
  source = "../../modules/compute"

  environment           = "production"
  region                = var.region
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = [module.networking.public_subnet_a_id, module.networking.public_subnet_b_id]
  private_subnet_ids    = [module.networking.private_subnet_a_id, module.networking.private_subnet_b_id]
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  desired_instances     = var.desired_instances
  health_check_path     = var.health_check_path
  health_check_port     = var.health_check_port
  artifact_bucket_name  = data.aws_s3_bucket.artifacts.id
  artifact_bucket_arn   = data.aws_s3_bucket.artifacts.arn
  application_artifact  = var.application_artifact
  certificate_arn       = module.certificate.certificate_arn
  db_secret_arn         = module.database.secret_arn
  db_security_group_id  = module.database.security_group_id
  uploads_bucket_name   = module.uploads_storage.uploads_bucket_name
  uploads_bucket_arn    = module.uploads_storage.uploads_bucket_arn
} 