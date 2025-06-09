#Resource Group
resource "azurerm_resource_group" "abhiTodo" {
  name     = "abhi-todo"
  location = "West Europe"
}

#Network Security Group(for port 22 )
resource "azurerm_network_security_group" "abhiNSG" {
  name                = "nsg-abhi"
  location            = azurerm_resource_group.abhiTodo.location
  resource_group_name = azurerm_resource_group.abhiTodo.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "todo_vnet" {
  name                = "abhi-vnet21"
  location            = azurerm_resource_group.abhiTodo.location
  resource_group_name = azurerm_resource_group.abhiTodo.name
  address_space       = ["80.0.0.0/16"]

#frontend subnet
  subnet {
    name             = "frontend-subnet"
    address_prefixes = ["80.0.1.0/24"]
    security_group = azurerm_network_security_group.abhiNSG.id
  }
#Backend subnet
  subnet {
    name             = "backend-subnet"
    address_prefixes = ["80.0.2.0/24"]
    security_group   = azurerm_network_security_group.abhiNSG.id
  }

}
#public IP-1
resource "azurerm_public_ip" "abhi-pip" {
  name                    = "todo-pip"
  location                = azurerm_resource_group.abhiTodo.location
  resource_group_name     = azurerm_resource_group.abhiTodo.name
  allocation_method       = "Dynamic"
  sku = "Basic"

  
}
#Public IP-2
resource "azurerm_public_ip" "abhi-pip1" {
  name                    = "todo-pip1"
  location                = azurerm_resource_group.abhiTodo.location
  resource_group_name     = azurerm_resource_group.abhiTodo.name
  allocation_method       = "Dynamic"
  sku = "Basic"

  
}
#Network Interface-1
resource "azurerm_network_interface" "abhi-nic" {
  name                = "todo-nic"
  location            = azurerm_resource_group.abhiTodo.location
  resource_group_name = azurerm_resource_group.abhiTodo.name

  ip_configuration {
    name                          = "frntconfigration"
    subnet_id                     = "/subscriptions/d2df2a41-202d-4062-831a-7223cf0df18f/resourceGroups/abhi-todo/providers/Microsoft.Network/virtualNetworks/abhi-vnet21/subnets/frontend-subnet"
    private_ip_address_allocation = "Dynamic"
     public_ip_address_id          = azurerm_public_ip.abhi-pip.id
  }
}
#Network Interface-2
resource "azurerm_network_interface" "abhi-nic1" {
  name                = "todo-nic1"
  location            = azurerm_resource_group.abhiTodo.location
  resource_group_name = azurerm_resource_group.abhiTodo.name

  ip_configuration {
    name                          = "backconfigration"
    subnet_id                     = "/subscriptions/d2df2a41-202d-4062-831a-7223cf0df18f/resourceGroups/abhi-todo/providers/Microsoft.Network/virtualNetworks/abhi-vnet21/subnets/backend-subnet"
    private_ip_address_allocation = "Dynamic"
       public_ip_address_id          = azurerm_public_ip.abhi-pip1.id
  }
}
#Linux VM-frontend
resource "azurerm_linux_virtual_machine" "abhiVM" {
  name                = "vm-frontend-abhi"
  resource_group_name = azurerm_resource_group.abhiTodo.name
  location            = azurerm_resource_group.abhiTodo.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
    admin_password = ""
    disable_password_authentication=false
  network_interface_ids = [
    azurerm_network_interface.abhi-nic.id,
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

#Linux VM-backend
resource "azurerm_linux_virtual_machine" "abhiVM1" {
  name                = "vm-backend-abhi"
  resource_group_name = azurerm_resource_group.abhiTodo.name
  location            = azurerm_resource_group.abhiTodo.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = ""
  disable_password_authentication=false
  network_interface_ids = [
    azurerm_network_interface.abhi-nic1.id,
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_mssql_server" "abhi-server" {
  name                         = "abhi-sqlserver-01"
  resource_group_name          = azurerm_resource_group.abhiTodo.name
  location                     = "Central India"
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = ""
  minimum_tls_version          = "1.2"
}
resource "azurerm_mssql_database" "sql-database" {
  name      = "abhi-mssql-db"
  server_id = azurerm_mssql_server.abhi-server.id
}
output "frontend_public_ip" {
  value = azurerm_public_ip.abhi-pip.ip_address
  
}
output "backend_public_ip" {
  value = azurerm_public_ip.abhi-pip1.ip_address
  
}