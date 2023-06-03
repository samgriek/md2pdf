variable "name" {}

resource "aws_ecr_repository" "repository" {
  name = var.name
}

output "repository_url" {
  value = aws_ecr_repository.repository.repository_url
}
