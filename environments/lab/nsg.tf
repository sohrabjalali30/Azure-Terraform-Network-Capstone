resource "azurerm_network_security_group" "management" {
  name                = "nsg-management"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  tags = {
    Company     = "STC-Tech"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_network_security_group" "frontend" {
  name                = "nsg-frontend"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  tags = {
    Company     = "STC-Tech"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_network_security_group" "backend" {
  name                = "nsg-backend"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  tags = {
    Company     = "STC-Tech"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}
resource "azurerm_network_security_rule" "frontend_allow_http" {
  name                       = "Allow-HTTP-Inbound"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "Internet"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.frontend.name
}
resource "azurerm_network_security_rule" "frontend_deny_vnet" {
  name                       = "Deny-VNet-Inbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.frontend.name
}
resource "azurerm_network_security_rule" "backend_allow_frontend" {
  name                       = "Allow-Frontend-8080"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "8080"
  source_address_prefix      = "10.20.1.0/24"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.backend.name
}
resource "azurerm_network_security_rule" "backend_allow_management_ssh" {
  name                       = "Allow-Management-SSH"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "10.10.1.0/24"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.backend.name
}
resource "azurerm_network_security_rule" "backend_deny_vnet" {
  name                       = "Deny-VNet-Inbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.backend.name
}
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.hub_management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = azurerm_subnet.spoke_frontend.id
  network_security_group_id = azurerm_network_security_group.frontend.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.spoke_backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}