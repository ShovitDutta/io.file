resource "azurerm_mssql_server" "positive" {
  name                = "example-sqlserver"
  resource_group_name = "example-rg"
  location            = "West Europe"
  version             = "12.0"
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username             = "AzureADAdmin"
    object_id                  = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = false
  }

  # No administrator_login present
  tags = {
    environment = "production"
  }
}