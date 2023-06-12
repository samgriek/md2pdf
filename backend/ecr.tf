resource "aws_ecr_repository" "api_repo" {
  name         = "md2pdf-api"
  force_delete = true
}
