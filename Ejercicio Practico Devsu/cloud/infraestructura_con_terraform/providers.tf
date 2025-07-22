###########################################################
# providers.tf – Inicialización de providers
###########################################################

provider "azurerm" {                          # Provider de Azure
  features {}                                  # Requerido por azurerm
}

provider "random" {}    