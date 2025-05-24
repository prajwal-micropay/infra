# Networking
module "networking" {
  source = "../../modules/networking"

  environment           = "production"
  vpc_cidr              = var.vpc_cidr
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b
} 