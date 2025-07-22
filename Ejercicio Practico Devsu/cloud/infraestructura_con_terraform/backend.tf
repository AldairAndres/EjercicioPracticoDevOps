terraform {                                # Configuración del backend remoto del estado.
  backend "azurerm" {                      # Se guarda el tfstate en Azure Blob Storage.
    resource_group_name  = "rg-tfstate"    # Resource Group donde vive la Storage Account que contiene el estado.
    storage_account_name = "sttfstate12345"# Nombre único de la Storage Account (sin mayúsculas ni guiones).
    container_name       = "tfstate"       # Contenedor Blob donde se almacena el archivo de estado.
    key                  = "infra-cloud.tfstate" # Nombre del blob que representará el estado de esta infra.
  }
}
