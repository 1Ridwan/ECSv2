resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "url-shortener-${var.env_name}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = {
    Environment = "${var.env_name}"
  }
}