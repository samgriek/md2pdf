resource "aws_ecr_repository" "api_repo" {
  name = "md2pdf-api"
  lifecycle {
    ignore_changes = all
  }
}
