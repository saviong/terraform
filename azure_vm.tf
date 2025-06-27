# Create a Resource Group
resource "azurerm_resource_group" "DemoRG" {
  name     = "Terraform-Demo-RG"
  location = "East US"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "DemoVnet" {
  name                = "Terraform-Demo-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# --- Create a Subnet ---
resource "azurerm_subnet" "DemoSubnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# --- Create a Public IP Address ---
resource "azurerm_public_ip" "public_ip" {
  name                = "Terraform-Demo-PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create a Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "Terraform-Demo-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create the Virtual Machine
resource "azurerm_linux_virtual_machine" "DemoVM" {
  name                  = "AzureVM-Terraform"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  # SSH Key Authentication
  # Using an SSH public key for authentication instead of a password.
  # The public key is taken from the tls_private_key resource we generated.
  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "<h1>Deployed with Terraform on Azure!</h1>" | sudo tee /var/www/html/index.html
    EOF
  )

  tags = {
    Name        = "WebServer-Azure-Terraform"
    Project     = "MultiCloud-Demo"
    Provisioner = "Terraform"
  }
}
