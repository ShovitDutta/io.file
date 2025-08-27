resource "azurerm_resource_group" "example" {
  name     = "test-resource-group-1"
  location = "East US"
}


resource "azurerm_cognitive_account" "negative1" {
  name                = "example-account"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  kind                = "OpenAI"
  sku_name = "S0"
  public_network_access_enabled = false

   tags = {
    itpmid = "12345"
    environmenttype = "dev"
    sharedemailaddress = "CloudSecurityServices@cvshealth.com"
    costcenter = "02045"
    dataclassification = "confidential"
  }
}