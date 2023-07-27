provider "azurerm" {
  features{}
  }

resource "azurerm_resource_group" "rgrepo" {
  name = "rgrepo"
  location ="westus"
  }
