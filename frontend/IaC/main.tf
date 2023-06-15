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

# must be manually applied
# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.ui_md2pdf_bucket.id

#   policy = <<-POLICY
#   {
#     "Version":"2012-10-17",
#     "Statement":[
#       {
#         "Sid":"PublicReadGetObject",
#         "Effect":"Allow",
#         "Principal": "*",
#         "Action":["s3:GetObject"],
#         "Resource":["arn:aws:s3:::${aws_s3_bucket.ui_md2pdf_bucket.id}/*"],
#         "Condition" : {
#           "IpAddress" : { 
#             "aws:SourceIp": [
#                 "173.245.48.0/20",
#                 "103.21.244.0/22",
#                 "103.22.200.0/22",
#                 "103.31.4.0/22",
#                 "141.101.64.0/18",
#                 "108.162.192.0/18",
#                 "190.93.240.0/20",
#                 "188.114.96.0/20",
#                 "197.234.240.0/22",
#                 "198.41.128.0/17",
#                 "162.158.0.0/15",
#                 "104.16.0.0/13",
#                 "104.24.0.0/14",
#                 "172.64.0.0/13",
#                 "131.0.72.0/22",
#                 "2400:cb00::/32",
#                 "2606:4700::/32",
#                 "2803:f800::/32",
#                 "2405:b500::/32",
#                 "2405:8100::/32",
#                 "2a06:98c0::/29",
#                 "2c0f:f248::/32"
#             ] 
#           }
#         }
#       }
#     ]
#   }
#   POLICY
# }

