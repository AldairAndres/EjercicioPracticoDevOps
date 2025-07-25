###########################################################
# providers.tf – Inicialización de providers
###########################################################

provider "azurerm" {                          # Provider de Azure
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

provider "random" {}    