provider "aws" {
  region = "us-west-2"
}

module "ecr" {
  source = "./modules/ecr"
  name   = "md2pdf"
}

module "iam" {
  source = "./modules/iam"
  name   = "md2pdf-role"
}

module "lambda" {
  source        = "./modules/lambda"
  role_arn      = module.iam.role_arn
  image_uri     = module.ecr.repository_url
  function_name = "md2pdf"
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  lambda_arn        = module.lambda.invoke_arn
  api_name          = "md2pdf-api"
  usage_plan_name   = "md2pdf-usage-plan"
  api_key_name      = "md2pdf-api-key"
}
