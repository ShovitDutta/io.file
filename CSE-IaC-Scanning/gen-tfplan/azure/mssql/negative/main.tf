resource "azurerm_mssql_server" "negative" {
  name                = "example-sqlserver"
  resource_group_name = "example-rg"
  location            = "West Europe"
  version             = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username             = "AzureADAdmin"
    object_id                  = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = true
  }

  # No administrator_login present
  tags = {
    environment = "production"
  }
}