terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "lognormalizertf"
    container_name       = "tfstate"
    key                  = "azure-function/terraform.tfstate"
  }
}

#creat first 
#Storage account lognormalizertf
#Blob container tfstate
#Resource group tfstate-rg