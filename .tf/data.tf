
// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app
resource "azurerm_storage_account" "storage_account" {
  name                     = replace(var.project_name, "-", "")
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
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

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_firewall_rule
resource "azurerm_mariadb_firewall_rule" "firewall" {
  name                = var.project_name
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mariadb_server.db_server.name
  start_ip_address    = var.allowed_ip_address
  end_ip_address      = var.allowed_ip_address
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_database
resource "azurerm_mariadb_database" "db_database" {
  name                = replace(var.project_name, "-", "_")
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mariadb_server.db_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_520_ci"
}
