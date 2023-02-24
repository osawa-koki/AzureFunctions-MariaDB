
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.project_name
  location = "japaneast"
}
