terraform {
  backend "azurerm" {
    use_cli              = true
    use_azuread_auth     = true
    storage_account_name = "ststctfxi5dg5"
    container_name       = "tfstate"
    key                  = "network-capstone.tfstate"
  }
}