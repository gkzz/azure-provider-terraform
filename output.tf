## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "main" {
}

output "azurerm_subscription_name" {
  value = data.azurerm_subscription.main.display_name
}

output "hostname" {
  value = var.hostname
}

output "public_ip_id" {
  description = "id of the public ip address provisoned."
  value       = azurerm_public_ip.main.*.id
}

output "admin_username" {
  value = var.admin_username
}

output "admin_password" {
  value = var.admin_password
}