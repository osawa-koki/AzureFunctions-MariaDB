
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

variable "ip_address_allowed" {
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

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.project_name
  location = "japaneast"
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.project_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key

  version                    = "~4"
  https_only                 = true

  app_settings = {
    "MY_ENV"  = "my_env_value"
  }

  connection_string {
    name      = "my_connection_string"
    type      = "MySQL"
    value     = "Server=${azurerm_mariadb_server.db_server.name}.mariadb.database.azure.com;Database=${azurerm_mariadb_database.db_database.name};Uid=${var.mariadb_admin_username}@${azurerm_mariadb_server.db_server.name};Pwd=${var.mariadb_admin_password}"
  }
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_server
resource "azurerm_mariadb_server" "db_server" {
  name                = var.project_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  administrator_login          = var.mariadb_admin_username
  administrator_login_password = var.mariadb_admin_password

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  ssl_enforcement_enabled       = false
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_database
resource "azurerm_mariadb_database" "db_database" {
  name                = replace(var.project_name, "-", "_")
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mariadb_server.db_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_520_ci"
}

resource "azurerm_mariadb_firewall_rule" "firewall" {
  name                = var.project_name
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mariadb_server.db_server.name
  start_ip_address    = var.ip_address_allowed
  end_ip_address      = var.ip_address_allowed
}

# 接続文字列を表示
output "connection_string" {
  value = azurerm_function_app.function_app.connection_string
  sensitive = true
}
