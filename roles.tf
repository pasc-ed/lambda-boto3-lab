resource "aws_iam_role" "lambda_assume_role" {
  name = "labs-lambda-assume-role"

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
      },
    ]
  })

  tags = {
    Name = "labs-lambda-assume-role"
  }
}

data "aws_iam_policy_document" "lab_lambda_for_rekognition" {
  statement {
    sid = "LambdaForRekognition"
    actions = [
      "rekognition:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lab_lambda_for_rekognition_policy" {
  name = "lab-lambda-for-rekognition"
  description = "Allow Lambda function to use rekognition"
  policy = data.aws_iam_policy_document.lab_lambda_for_rekognition.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.lab_lambda_for_rekognition_policy.arn
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lab_lambda_image_rekognition.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.image_storage_bucket.arn
}