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

output "dns_validation" {
  value = aws_acm_certificate.alb_cert.domain_validation_options
  description = "The DNS validation records"
}
