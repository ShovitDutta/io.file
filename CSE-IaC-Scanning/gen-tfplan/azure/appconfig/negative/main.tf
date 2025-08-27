resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_app_configuration" "negative" {
  name                       = "appConf2"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  sku                        = "standard"
  local_auth_enabled         = false
  public_network_access      = "Disabled"
  purge_protection_enabled   = false
  soft_delete_retention_days = 1

  replica {
    name     = "replica1"
    location = "West US"
  }

   tags = {
    itpmid = "12345"
    environmenttype = "dev"
    sharedemailaddress = "CloudSecurityServices@cvshealth.com"
    costcenter = "02045"
    dataclassification = "confidential"
  }
}

resource "azurerm_private_endpoint" "example" {
  name                = "example-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_app_configuration.negative.id
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
  }
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.azure.com"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "service"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}