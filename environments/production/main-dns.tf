# DNS records
module "dns_records" {
  source = "../../modules/dns/records"

  environment     = "production"
  domain_name     = var.domain_name
  hosted_zone_id  = var.hosted_zone_id
  certificate_arn = module.certificate.certificate_arn
  domain_validation_options = module.certificate.domain_validation_options
  alb_dns_name    = module.compute.alb_dns_name
  alb_zone_id     = module.compute.alb_zone_id

  depends_on = [module.compute, module.certificate]
} 