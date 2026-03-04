variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "db_password" {
  description = "Aurora DB password"
  type        = string
  sensitive   = true
}