#
# Route53
#
resource "aws_route53_zone" "host_domain" {
  name = var.host_domain
}

resource "aws_route53_zone" "app_subdomain" {
  name = var.app_domain_name
}

resource "aws_route53_record" "route53_acm_dns_resolve" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  type = each.value.type
  ttl = "300"

  zone_id = aws_route53_zone.host_domain.id
}

resource "aws_route53_record" "ns_record_for_app_subdomain" {
  name    = aws_route53_zone.app_subdomain.name
  type    = "NS"
  zone_id = aws_route53_zone.host_domain.id
  records = [
    aws_route53_zone.app_subdomain.name_servers[0],
    aws_route53_zone.app_subdomain.name_servers[1],
    aws_route53_zone.app_subdomain.name_servers[2],
    aws_route53_zone.app_subdomain.name_servers[3],
  ]
  ttl = 172800
}

#
# 証明書
#
resource "aws_acm_certificate" "cert" {
  domain_name               = "*.${var.host_domain}"
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "acm"
  }
}