# get data for existing hosted zone

data "aws_route53_zone" "primary" {
  name         = var.apex_domain
}

# ACM certificate that covers apex 
resource "aws_acm_certificate" "main" {
  domain_name               = var.apex_domain
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# create CNAME record in hosted zone DNS records to prove that i own this domain

resource "aws_route53_record" "validate" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

# validate certificate

resource "aws_acm_certificate_validation" "cert_validate" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validate : record.fqdn]
}

# make domain point to ALB through A record
resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = data.aws_route53_zone.primary.name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}