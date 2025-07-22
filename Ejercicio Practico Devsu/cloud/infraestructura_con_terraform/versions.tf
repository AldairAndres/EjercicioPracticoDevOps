###########################################################
# versions.tf – Configuración de versión y proveedores
###########################################################

terraform {                                   # Bloque raíz de Terraform
  required_version = ">= 1.6.0"               # Asegura versión reciente

  required_providers {                        # Definición de proveedores requeridos
    azurerm = {
      source  = "hashicorp/azurerm"           # Provider oficial de Azure
      version = "~> 4.37"                      # Línea 4.x (API actual de AKS)
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Backend remoto opcional. Mantener comentado si se usará local.
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"      # RG donde vive el storage del estado
  #   storage_account_name = "tfstateacct123"  # Nombre único
  #   container_name       = "tfstate"
  #   key                  = "main.tfstate"
  # }
}