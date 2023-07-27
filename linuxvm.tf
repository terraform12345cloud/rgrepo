provider "azurerm" {
  features {}

  client_id       = "785e245a-dd03-44fa-9a4f-3f2f6a444aca"
  client_secret   = "o5j8Q~YSek2IBQNaZ9F1zi2gYrvg4nBBxuyUdbO5"
  tenant_id       = "34911f0f-04cb-4b25-931e-6e89ba2bf285"
  subscription_id = "1b7af85e-c5fa-473a-9c31-b5adda6960ca"
}

resource "azurerm_resource_group" "linux-rg" {
  name     = "linux-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "linux-vnet0" {
  name                = "linux-vnet0"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name
}

resource "azurerm_subnet" "linux-snet0" {
  name                 = "linux-snet0"
  resource_group_name  = azurerm_resource_group.linux-rg.name
  virtual_network_name = azurerm_virtual_network.linux-vnet0.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "linux-nic0" {
  name                = "linux-nic0"
  location            = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.linux-snet0.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.linux-rg.name
  location            = azurerm_resource_group.linux-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Chinmay@12345"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.linux-nic0.id
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
