terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-stctech-tfstate-uaenorth"
  location = "UAE North"

  tags = {
    Company     = "STC-Tech"
    Environment = "Shared"
    Workload    = "Terraform-State"
    ManagedBy   = "Terraform"
    Criticality = "Infrastructure"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "ststctf${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    Company     = "STC-Tech"
    Environment = "Shared"
    Workload    = "Terraform-State"
    ManagedBy   = "Terraform"
    Criticality = "Infrastructure"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "tfstate_blob_contributor" {
  scope                = azurerm_storage_container.tfstate.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.current_user_object_id
}