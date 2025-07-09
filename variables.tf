variable "table_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "region" {
  type = string
}

variable "http_methods" {
  default = ["GET", "PUT", "POST", "DELETE"]
  type    = list(string)
}