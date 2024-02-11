# to store terraform state file in s3 bucket
terraform {
  backend "s3" {
    bucket = "test-bucket-1212012"
    key    = "lambda/helloworld.tfstate"
    region = "us-east-1"

  }
}


# to install terraform latest version
terraform {
  required_version = ">=1.5.6"
}


provider "aws" {
  region = "us-east-1"
}

# to create zip file
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "test.py"
  output_path = "test.zip"
}


resource "aws_iam_role" "role" {
  name = "lambda1_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name = "lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:Describe*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
  

# to create lambda function
resource "aws_lambda_function" "test_lambda" {
  function_name    = "lambda"
  role             = aws_iam_role.role.arn
  handler          = "test.lambda_handler"
  filename         = "test.zip"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda.output_base64sha256
}