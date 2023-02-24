
variable "project_name" {
  type        = string
  description = "Project name"
}

variable "mariadb_admin_username" {
  type        = string
  description = "MariaDB Server administrator username."
}

variable "mariadb_admin_password" {
  type        = string
  description = "MariaDB Server administrator password."
}

variable "allowed_ip_address" {
  type        = string
  description = "IP address which is allowed to access to database."
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name."
}

variable "function_app_name" {
  type        = string
  description = "Function app name."
}
