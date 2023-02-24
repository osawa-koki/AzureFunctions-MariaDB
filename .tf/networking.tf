
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  name           = "${var.project_name}-subnet"
  address_prefixes = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  delegation {
    name = "${var.project_name}-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                      = azurerm_subnet.subnet.id
  network_security_group_id      = azurerm_network_security_group.nsg.id
}

resource "azurerm_mariadb_virtual_network_rule" "mariadb_vnet_rule" {
  name                = "${var.project_name}-mariadb-vnet-rule"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mariadb_server.db_server.name
  subnet_id           = azurerm_subnet.subnet.id
}

resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = "${var.project_name}-allow-mariadb"
  resource_group_name         = azurerm_resource_group.resource_group.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefixes     = [var.allowed_ip_address]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_subnet_assoc" {
  app_service_id = azurerm_linux_function_app.function_app.id
  subnet_id      = azurerm_subnet.subnet.id
}
