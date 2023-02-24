
resource "azurerm_service_plan" "service_plan" {
  name                = var.project_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app.html

resource "azurerm_linux_function_app" "function_app" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  service_plan_id            = azurerm_service_plan.service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key

  site_config {
  }

  app_settings = {
    "MY_ENV" = "my-env"
  }

  connection_string {
    name      = "MY_CONNECTION_STRING"
    type      = "MySql"
    value     = "Server=${azurerm_mariadb_server.db_server.name}.mariadb.database.azure.com;Database=${azurerm_mariadb_database.db_database.name};Uid=${var.mariadb_admin_username}@${azurerm_mariadb_server.db_server.name};Pwd=${var.mariadb_admin_password}"
  }

  virtual_network_subnet_id = azurerm_subnet.subnet.id
}
