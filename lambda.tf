data "archive_file" "zip_file1" {
  type        = "zip"
  source_file = "lambda_function/add_employee/lambda_function.py"
  output_path = "lambda_function/add_employee/lambda_function.zip"
}

data "archive_file" "zip_file2" {
  type        = "zip"
  source_file = "lambda_function/get_employee/lambda_function.py"
  output_path = "lambda_function/get_employee/lambda_function.zip"
}

data "archive_file" "zip_file3" {
  type        = "zip"
  source_file = "lambda_function/remove_employee/lambda_function.py"
  output_path = "lambda_function/remove_employee/lambda_function.zip"
}

data "archive_file" "zip_file4" {
  type        = "zip"
  source_file = "lambda_function/update_employee/lambda_function.py"
  output_path = "lambda_function/update_employee/lambda_function.zip"
}

resource "aws_lambda_function" "dynamodb_add_employee" {
  function_name    = "dynamodb_add_employee"
  role             = aws_iam_role.lambda_crud_role.arn
  filename         = data.archive_file.zip_file1.output_path
  runtime          = "python3.13"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.zip_file1.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.employee_table.name
    }
  }
}

resource "aws_lambda_function" "dynamodb_get_employee" {
  function_name    = "dynamodb_get_employee"
  role             = aws_iam_role.lambda_crud_role.arn
  filename         = data.archive_file.zip_file2.output_path
  runtime          = "python3.13"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.zip_file2.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.employee_table.name
    }
  }
}

resource "aws_lambda_function" "dynamodb_remove_employee" {
  function_name    = "dynamodb_remove_employee"
  role             = aws_iam_role.lambda_crud_role.arn
  filename         = data.archive_file.zip_file3.output_path
  runtime          = "python3.13"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.zip_file3.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.employee_table.name
    }
  }
}

resource "aws_lambda_function" "dynamodb_update_employee" {
  function_name    = "dynamodb_update_employee"
  role             = aws_iam_role.lambda_crud_role.arn
  filename         = data.archive_file.zip_file4.output_path
  runtime          = "python3.13"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.zip_file4.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.employee_table.name
    }
  }
}