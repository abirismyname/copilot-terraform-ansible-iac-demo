terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.60.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "aws" {
  region = "us-east-1"
} 
