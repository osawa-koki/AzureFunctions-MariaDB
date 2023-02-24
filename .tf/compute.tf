
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.project_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app.html
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
