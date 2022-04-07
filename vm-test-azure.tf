
# --------------------------------------------------------------------------------------------------
# TEST VM Password
# --------------------------------------------------------------------------------------------------

resource "random_password" "admin_password" {
  length  = 16
  special = false
  #override_special = "!#$%&*()_=+[]{}<>:?"
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.vpn-rg.name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = var.azure_vm_subnet_prefix

}


resource "azurerm_network_security_group" "nsg-test-azure-vm" {
  name                = "vm-test-nsg"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
}


resource "azurerm_network_security_rule" "nsg-test-azure-vm-rule-1" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${data.http.source_ip.body}/32"
  destination_address_prefix  = "*"
  description                 = "Test-SSH."
  resource_group_name         = azurerm_resource_group.vpn-rg.name
  network_security_group_name = azurerm_network_security_group.nsg-test-azure-vm.name
}

resource "azurerm_network_security_rule" "nsg-test-azure-vm-rule-2" {
  name                        = "icmp"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.aws_vnet_prefix
  destination_address_prefix  = "*"
  description                 = "Test-ICMP"
  resource_group_name         = azurerm_resource_group.vpn-rg.name
  network_security_group_name = azurerm_network_security_group.nsg-test-azure-vm.name
}





resource "azurerm_network_interface_security_group_association" "vm-sg-asoc" {
  network_interface_id      = azurerm_network_interface.nic-test-azure-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-test-azure-vm.id
}



resource "azurerm_public_ip" "pip-test-azure-vm" {
  name                = "pip-test-azure-vm"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}


resource "azurerm_network_interface" "nic-test-azure-vm" {
  name                = "nic-test-azure-vm"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-test-azure-vm.id
  }
}

resource "azurerm_linux_virtual_machine" "vpn-test-azure-vm" {
  name                            = "vpn-test-azure-vm"
  location                        = var.azure_location
  resource_group_name             = azurerm_resource_group.vpn-rg.name
  size                            = "Standard_F2"
  disable_password_authentication = true
  admin_username                  = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.nic-test-azure-vm.id,
  ]

 admin_ssh_key {
    username   = "ubuntu"
    public_key = file("./ssh-keys/sshkey.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}



output "Azure_Test_VM_Public_IP" {
  description = "Azure Test VM Public IP"
  value = azurerm_public_ip.pip-test-azure-vm.ip_address
}

output "Azure_Test_VM_Private_IP" {
  description = "Azure Test VM Private IP"
  value = azurerm_linux_virtual_machine.vpn-test-azure-vm.private_ip_address
}


