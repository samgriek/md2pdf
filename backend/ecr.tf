resource "aws_ecr_repository" "api_repo" {
  name = "md2pdf-api"
  lifecycle {
    ignore_changes = all
  }
}


resource "aws_ecr_repository" "ui_repo" {
  name = "md2pdf"
  lifecycle {
    ignore_changes = all
  }
}
