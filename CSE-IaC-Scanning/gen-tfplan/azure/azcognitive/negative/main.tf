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
  customer_managed_key {
    key_vault_key_id = azurerm_key_vault_key.example2.id
  }
}


resource "azurerm_key_vault" "example2" {
  name                     = "example-vault"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  tenant_id                = data.azurerm_client_config.current1.tenant_id
  sku_name                 = "standard"
}

resource "azurerm_key_vault_key" "example2" {
  name         = "example-key"
  key_vault_id = azurerm_key_vault.example2.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}


data "azurerm_client_config" "current1" {}