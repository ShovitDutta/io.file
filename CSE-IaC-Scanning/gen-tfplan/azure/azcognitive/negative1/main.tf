resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_cognitive_account" "negative1" {
  name                = "example-account"
  location            = "West Europe"
  resource_group_name = "example-resources"
  kind                = "OpenAI"
  sku_name = "S0"
  public_network_access_enabled = false
  outbound_network_access_restricted = true
  fqdns = ["example.cvs.com"]

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
  location            = "West Europe"
  resource_group_name = "example-resources"
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.negative1.id
    is_manual_connection           = false
  }
}