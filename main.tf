resource "azurerm_public_ip" "this" {
  count               = var.enable_public_ip_address == true ? 1 : 0
  name                = "public-ip-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Ip configuration
  ip_configuration {
    name                          = "ip-configuration-${var.suffix}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.enable_public_ip_address == true ? azurerm_public_ip.this[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = "vm-${var.suffix}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.this.id]

  os_disk {
    name                 = "ubuntu-disk-${var.suffix}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
