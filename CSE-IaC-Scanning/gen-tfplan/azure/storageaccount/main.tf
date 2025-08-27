data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
resource "azurerm_user_assigned_identity" "example" {
  location            = azurerm_resource_group.example.location
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_key_vault" "example" {
  name                = "examplekv"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = true
}

resource "azurerm_storage_account" "allowed" {
  name = "sample"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location

  # Only General Purpose V2 account shall be used . account_kind is set to StorageV2
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  min_tls_version           = "TLS1_2"

  blob_properties {
    last_access_time_enabled = true
    delete_retention_policy {
      days = 5
    }
  }

  customer_managed_key {
    key_vault_key_id  = azurerm_key_vault.example.id
    user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  }

  identity {
    type = "SystemAssigned, UserAssigned"
  }
}