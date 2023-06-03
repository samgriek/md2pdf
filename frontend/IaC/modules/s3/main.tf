resource "aws_s3_bucket" "bucket" {
  bucket = "md2pdf-fronted" # replace with your bucket name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
