# Summary

This is a module which creates the following resources:

- Linux Virtual Machine
- Network Interface Card
- Public IP (depending on the input variable)

# Example

The following is an example of how to use the module:

```
resource "azurerm_resource_group" "this" {
  name     = "test-rg"
  location = "australiaeast"
}

module "vnet" {
  source              = "git::https://github.com/mason1999/terraform-vnet-subnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  suffix              = "testing"
  address_space       = ["10.0.0.0/16"]
  subnet_address_spaces = {
    a = ["10.0.0.0/24"]
    b = ["10.0.1.0/24"]
  }
}

module "linux_vm" {
  source = "git::https://github.com/mason1999/terraform-linux-vm"

  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  suffix                        = "testing"
  subnet_id                     = module.vnet.subnet_ids.a
  enable_public_ip_address      = true
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.0.0.4"
  admin_username                = "testuser"
  admin_password                = "WeakPassword123"
}
```
