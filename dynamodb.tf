resource "aws_dynamodb_table" "employee_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "employee_id"
  range_key    = "department_id"
  attribute {
    type = "S"
    name = "employee_id"
  }
  attribute {
    type = "S"
    name = "department_id"
  }
  tags = {
    Environment = var.environment
    Name        = var.table_name
  }
}