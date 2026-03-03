variable "primary_region" {
  type    = string
  default = "ap-south-1"
}

variable "secondary_region" {
  type    = string
  default = "us-east-1"
}

variable "db_password" {
  type      = string
  sensitive = true
}