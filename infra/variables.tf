variable "primary_region" {
  description = "Region for EKS and VPC"
  type        = string
  default     = "ap-south-1"
}

variable "db_region" {
  description = "Region for Aurora database"
  type        = string
  default     = "us-east-1"
}

variable "db_password" {
  description = "Aurora DB password"
  type        = string
  sensitive   = true
}