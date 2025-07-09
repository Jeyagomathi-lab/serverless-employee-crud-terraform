output "api_key" {
  value = aws_api_gateway_api_key.apikey.value
  sensitive = true
}
output "api_endpoint" {
  value = "https://${aws_api_gateway_rest_api.employee_api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.stage.stage_name}/employee"
}