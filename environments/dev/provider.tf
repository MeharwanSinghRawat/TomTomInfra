terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }

}
provider "azurerm" {
  features {}
  subscription_id = "20562d9f-bc4e-4f13-86df-a64964f225bf"
}





