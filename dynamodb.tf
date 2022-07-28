resource "aws_dynamodb_table" "lambda_image_rekognition" {
  name           = "lambda-image-metadata"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "filename"

  attribute {
    name = "filename"
    type = "S"
  }

  tags           = {
    Name = "lambda-image-rekognition"
  }
}