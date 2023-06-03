variable "role_arn" {}
variable "image_uri" {}
variable "function_name" {}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  image_uri     = var.image_uri
  package_type  = "Image"
  role          = var.role_arn
  timeout       = 60
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_function.invoke_arn
}
