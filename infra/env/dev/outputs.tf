output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "alb dns name to be used by route53 module"
}
