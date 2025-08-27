data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
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
  public_network_access_enabled = true

  blob_properties {
    last_access_time_enabled = true
    delete_retention_policy {
      days = 5
    }
  }
}