variable "prefix" {
  default = "tf"
}

variable "environment" {
  default = "dev"
}

variable "hostname" {
  default = "tf-vm"
}

variable "subscription_id" {

}

variable "tenant_id" {

}

#https://github.com/claranet/terraform-azurerm-regions/blob/master/REGIONS.md
variable "location" {
  #default = "eastus"
  default = "jap-east"
}

variable "admin_username" {

}

variable "admin_password" {

}
