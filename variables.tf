variable "db_password" {
  description = "The password for the MySQL RDS database"
  type        = string
  sensitive   = true
}
