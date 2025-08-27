resource "azurerm_key_vault" "positive2" {
  name                        = "examplekeyvault"
  location                    = "West Europe"
  resource_group_name         = "kv-rg"
  tenant_id                   = "123"
  sku_name = "premium"
  purge_protection_enabled    = true
  enable_rbac_authorization   = true

  tags = {
    itpmid = 02345
    environmenttype = "dev"
    sharedemailaddress = "CloudSecurityServices@cvshealth.com"
    dataclassification = "confidential"
    costcenter = "02045"
  }
}

resource "azurerm_private_endpoint" "positiveexample1" {
  name                = "example-endpoint"
  location            = "West Europe"
  resource_group_name = "kv-rg"
  subnet_id           = "azurerm_subnet.endpoint.id"

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.positive1.id
    is_manual_connection           = false
  }
}

resource "azurerm_key_vault" "positive12" {
  name                        = "examplekeyvault"
  location                    = "West Europe"
  resource_group_name         = "kv-rg"
  tenant_id                   = "123"
  sku_name = "premium"
  public_network_access_enabled = true
  purge_protection_enabled    = true
  enable_rbac_authorization   = true

  tags = {
    itpmid = 02345
    environmenttype = "dev"
    sharedemailaddress = "CloudSecurityServices@cvshealth.com"
    dataclassification = "confidential"
    costcenter = "02045"
  }
}

resource "azurerm_private_endpoint" "positiveexample2" {
  name                = "example-endpoint"
  location            = "West Europe"
  resource_group_name = "kv-rg"
  subnet_id           = "azurerm_subnet.endpoint.id"

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.positive12.id
    is_manual_connection           = false
  }
}