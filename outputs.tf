output "public_ip" {
  value = var.enable_public_ip_address == true ? azurerm_public_ip.this[0].ip_address : null
}
