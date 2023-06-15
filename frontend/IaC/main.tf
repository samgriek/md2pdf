provider "aws" {
  region = "us-west-2"
}


resource "aws_s3_bucket" "ui_md2pdf_bucket" {
  bucket = "ui-md2pdf"
}

resource "aws_s3_bucket_ownership_controls" "ui_md2pdf_bucket_controls" {
  bucket = aws_s3_bucket.ui_md2pdf_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "ui_md2pdf_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ui_md2pdf_bucket_controls]

  bucket = aws_s3_bucket.ui_md2pdf_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.ui_md2pdf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "ui_md2pdf_bucket_website_configuration" {
  bucket = aws_s3_bucket.ui_md2pdf_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

data "aws_route53_zone" "griekinc" {
  name = "griekinc.com"
}

resource "aws_route53_record" "md2pdf" {
  zone_id = data.aws_route53_zone.griekinc.zone_id
  name    = "md2pdf.griekinc.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "us_east_1_cert" {
  provider            = aws.useast1
  domain_name         = "griekinc.com"
  validation_method   = "DNS"
  subject_alternative_names = ["*.griekinc.com"]
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for md2pdf.griekinc.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "S3 Distribution for md2pdf.griekinc.com"

  origin {
    domain_name = aws_s3_bucket.ui_md2pdf_bucket.bucket_regional_domain_name
    origin_id   = "ui-md2pdf"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "ui-md2pdf"

    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept-Encoding", "Access-Control-Request-Method", "Access-Control-Request-Headers"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  viewer_certificate {
  acm_certificate_arn      = aws_acm_certificate.us_east_1_cert.arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
}

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "md2pdf-cloudfront-distribution"
    Environment = "production"
  }
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

