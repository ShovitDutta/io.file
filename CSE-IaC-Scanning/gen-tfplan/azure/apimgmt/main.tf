terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.117.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_api_management" "negative" {
  name                          = "example-apim"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  publisher_name                = "My Company"
  publisher_email               = "company@mycompany.io"
  virtual_network_type          = "Internal"
  public_network_access_enabled = false
  sku_name                      = "Premium_1"

  security {
    enable_backend_tls11  = false
    enable_frontend_tls11 = false
  }

  tags = {
    itpmid             = "12345"
    environmenttype    = "dev"
    sharedemailaddress = "CloudSecurityServices@cvshealth.com"
    costcenter         = "02045"
    dataclassification = "confidential"
  }
}