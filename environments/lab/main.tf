resource "azurerm_resource_group" "network" {
  name     = "rg-stctech-network-lab-uaenorth"
  location = var.location

  tags = {
    Company     = "STC-Tech"
    Environment = "Lab"
    Project     = "Azure-Terraform-Network-Capstone"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-stctech-hub"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.10.0.0/16"]

  tags = {
    Company     = "STC-Tech"
    Environment = "Lab"
    Role        = "Hub"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_virtual_network" "spoke_app" {
  name                = "vnet-stctech-spoke-app"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.20.0.0/16"]

  tags = {
    Company     = "STC-Tech"
    Environment = "Lab"
    Role        = "Application-Spoke"
    ManagedBy   = "Terraform"
  }
}
resource "azurerm_subnet" "hub_management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "hub_shared_services" {
  name                 = "snet-shared-services"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_subnet" "spoke_frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.spoke_app.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "spoke_backend" {
  name                 = "snet-backend"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.spoke_app.name
  address_prefixes     = ["10.20.2.0/24"]
}

resource "azurerm_subnet" "spoke_private_endpoint" {
  name                 = "snet-private-endpoint"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.spoke_app.name
  address_prefixes     = ["10.20.3.0/24"]
}