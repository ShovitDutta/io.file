resource "azurerm_key_vault" "negative1" {
  name                        = "examplekeyvault"
  location                    = "West Europe"
  resource_group_name         = "kv-rg"
  tenant_id                   = "123"
  sku_name = "premium"
  public_network_access_enabled = false
  purge_protection_enabled    = true
  enable_rbac_authorization   = true
  
  tags = {
    itpmid = 0234
    environmenttype = "dev"
    sharedemailaddress = "CloudSecurityServices@cvshealth.com"
    costcenter = "02045"
    dataclassification = "confidential"
  }
}

resource "azurerm_private_endpoint" "negativeexample" {
  name                = "example-endpoint"
  location            = "West Europe"
  resource_group_name = "kv-rg"
  subnet_id           = "azurerm_subnet.endpoint.id"

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.negative1.id
    is_manual_connection           = false
  }
}