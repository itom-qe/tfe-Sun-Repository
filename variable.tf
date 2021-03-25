variable "subscriptionId" {
}

variable "clientId" {
}

variable "clientSecret" {
}

variable "tenantId" {
}

variable "rg" {
    description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
    default = "ResourceGroup"
  }




variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "azuretg"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default     = "tf"
}

variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = "vm"
}

variable "lb_ip_dns_name" {
  description = "DNS for Load Balancer IP"
  default     = "lb1"
}

variable "vm_count_per_subnet" {
  description = "count per subnet"
  default     = 2
}

variable "region" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "network" {
  description = "The name for the virtual network."
  default     = "AutoNetwork"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}
variable "subnet"{
description = "Defines the subnetname"
default = "autosubnet"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D1_v2"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "MicrosoftWindowsServer"
}



variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "2012-R2-Datacenter"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
  default     = "admin01!"
}
