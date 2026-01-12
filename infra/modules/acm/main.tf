data "aws_route53_zone" "primary" {
  name         = var.apex_domain
}

resource "aws_route53_zone" "dev" {
  name = "${var.env_name}.${var.apex_domain}"

  tags = {
    Environment = "${var.env_name}"
  }
}

# ACM certificate that covers subdomain
resource "aws_acm_certificate" "main" {
  domain_name               = "${var.env_name}.${var.apex_domain}"
  # subject_alternative_names = [var.sub_domain]
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

# make subdomain point to ALB
resource "aws_route53_record" "tm" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.env_name}.${var.apex_domain}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}