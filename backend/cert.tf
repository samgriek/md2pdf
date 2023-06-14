resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "api-md2pdf.griekinc.com"
  validation_method = "DNS"

  subject_alternative_names = ["*.griekinc.com"]

  tags = {
    Name = "api-md2pdf-griekinc-com-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_zone" "griekinc" {
  name = "griekinc.com"
}


resource "aws_route53_record" "validation" {
  name    = element(tolist(aws_acm_certificate.alb_cert.domain_validation_options), 0).resource_record_name
  type    = element(tolist(aws_acm_certificate.alb_cert.domain_validation_options), 0).resource_record_type
  zone_id = aws_route53_zone.griekinc.zone_id
  records = [element(tolist(aws_acm_certificate.alb_cert.domain_validation_options), 0).resource_record_value]
  ttl     = 60
}


resource "aws_route53_record" "api_record" {
  zone_id = aws_route53_zone.griekinc.zone_id
  name    = "api-md2pdf"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
