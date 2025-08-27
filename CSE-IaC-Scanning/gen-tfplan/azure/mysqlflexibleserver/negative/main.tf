resource "azurerm_resource_group" "example" {
  name     = "ExampleResourceGroup"
  location = "West Europe"
}

resource "azurerm_key_vault_key" "example" {
  name         = "generated-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                        = "examplekeyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_mysql_flexible_server" "negative" {
  name                   = "example-mysql-fs"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "sqladmin"
  administrator_password = "V@hS1YoE3!"
  backup_retention_days  = 7
  sku_name               = "GP_Standard_D2ds_v4"
  customer_managed_key {
    key_vault_key_id = azurerm_key_vault_key.example.id
  }
}