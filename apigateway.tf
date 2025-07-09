resource "aws_api_gateway_rest_api" "employee_api" {
    name = "serverless_employee_crud"
}

resource "aws_api_gateway_resource" "employee_resource" {
    path_part = "employee"
    parent_id = aws_api_gateway_rest_api.employee_api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.employee_api.id 
}

locals {
  lambda_arns = {
    POST    = aws_lambda_function.dynamodb_add_employee.arn
    GET     = aws_lambda_function.dynamodb_get_employee.arn
    PUT     = aws_lambda_function.dynamodb_update_employee.arn
    DELETE  = aws_lambda_function.dynamodb_remove_employee.arn
  }
}
locals{
  lambda_uris = {
    POST    = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.dynamodb_add_employee.arn}/invocations"
    GET     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.dynamodb_get_employee.arn}/invocations"
    PUT     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.dynamodb_update_employee.arn}/invocations"
    DELETE  = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.dynamodb_remove_employee.arn}/invocations"
  }
}


resource "aws_api_gateway_method" "methods" {
    for_each = local.lambda_arns
    rest_api_id = aws_api_gateway_rest_api.employee_api.id
    resource_id = aws_api_gateway_resource.employee_resource.id
    http_method = each.key
    authorization = "NONE"
    api_key_required = true
  
}

resource "aws_api_gateway_integration" "apiintegration" {
    for_each = aws_api_gateway_method.methods
    rest_api_id = each.value.rest_api_id
    resource_id = each.value.resource_id
    http_method = each.key
    type = "AWS_PROXY"
    uri = local.lambda_uris[each.key]
    integration_http_method = "POST"
}


resource "aws_api_gateway_deployment" "deployment" {
    rest_api_id = aws_api_gateway_rest_api.employee_api.id
    depends_on = [ aws_api_gateway_integration.apiintegration,
                   aws_api_gateway_method.methods]  
}

resource "aws_api_gateway_stage" "stage" {
    rest_api_id = aws_api_gateway_rest_api.employee_api.id
    deployment_id = aws_api_gateway_deployment.deployment.id
    stage_name = "dev" 
}

################### Creation of api key ###################

resource "aws_api_gateway_api_key" "apikey" {
    name = "employee_api_key_dev"
    enabled = true
    description = "api key for dev stage"
}

resource "aws_api_gateway_usage_plan" "usageplan" {
  name = "dev-employee-key-usage-plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.employee_api.id
    stage = aws_api_gateway_stage.stage.stage_name
  }
  throttle_settings {
    rate_limit = 10
    burst_limit = 2
  }
  quota_settings {
    period = "MONTH"
    limit = 1000
  }
}

resource "aws_api_gateway_usage_plan_key" "attachkeytoplan" {
    key_id = aws_api_gateway_api_key.apikey.id
    usage_plan_id = aws_api_gateway_usage_plan.usageplan.id
    key_type = "API_KEY"
}


resource "aws_lambda_permission" "AllowApigatewayToInvokeLambda" {
    for_each = local.lambda_arns
    function_name = each.value
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.employee_api.execution_arn}/dev/${each.key}/employee"
}