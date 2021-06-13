# https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/virtual-machines/windows/basic-password/main.tf
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli
# https://owendavies.net/articles/create-azure-virtual-machine-with-terraform/



/*
https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure

tags = {
        environment = "Terraform Demo"
}
*/


terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "${var.environment}"
  }
}

########################
## https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/virtual-machines/virtual_machine/multiple-network-interfaces/main.tf#L35
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = {
    environment = "${var.environment}"
  }
}



## https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/virtual-machines/virtual_machine/multiple-network-interfaces/main.tf#L60
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow_RDP"
    description                = "Allow RDP access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.environment}"
  }
}
