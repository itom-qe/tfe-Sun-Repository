provider "azurerm" {
  subscription_id = var.subscriptionId
  client_id       = var.clientId
  client_secret   = var.clientSecret
  tenant_id       = var.tenantId
  #version = "=2.0.0"
  version = "=1.44.0"
  #features {}
}
