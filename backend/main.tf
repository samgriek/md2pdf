provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "repository" {
  name = "md2pdf"
}

resource "aws_iam_role" "role" {
  name = "md2pdf-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "md2pdf_function" {
  function_name = "md2pdf"

  image_uri = "${aws_ecr_repository.repository.repository_url}:latest"

  package_type = "Image"
  role         = aws_iam_role.role.arn
  timeout      = 60
}

resource "aws_apigatewayv2_api" "api" {
  name          = "md2pdf-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.md2pdf_function.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api.id
  name   = "default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.md2pdf_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name        = "md2pdf-usage-plan"
  description = "A usage plan for my API"

  api_stages {
    api_id = aws_apigatewayv2_api.api.id
    stage  = aws_apigatewayv2_stage.stage.name
  }

  quota_settings {
    limit  = 100
    offset = 0
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 1
    rate_limit  = 3
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name        = "md2pdf-api-key"
  description = "md2pdf API Key"
  enabled     = true
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}
