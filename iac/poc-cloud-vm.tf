# resource "azurerm_linux_virtual_machine" "poc-vm" {
#   name                = "poc-vm"
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   location            = azurerm_resource_group.msc-rg.location
#   size                = "Standard_B2ats_v2"
# 
#   network_interface_ids = [
#     azurerm_network_interface.poc-nic.id,
#   ]
# 
#   admin_username                  = "debian"
#   disable_password_authentication = true
# 
#   admin_ssh_key {
#     username   = "debian"
#     public_key = file("./sshkeys/sander-key.pub")
#   }
# 
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#     disk_size_gb         = 40
#     name                 = "poc-vm-os-disk"
#   }
# 
#   boot_diagnostics {
#     storage_account_uri = "https://mscprodst.blob.core.windows.net/"
#   }
# 
#   identity {
#     type = "SystemAssigned"
#   }
# 
#   source_image_reference {
#     publisher = "Debian"
#     offer     = "debian-11"
#     sku       = "11-backports-gen2"
#     version   = "latest"
#   }
# }
# 
# resource "azurerm_public_ip" "poc-vm-public-ip" {
#   name                = "poc-ip"
#   location            = azurerm_resource_group.msc-rg.location
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   ip_version          = "IPv4"
# }
# 
# resource "azurerm_network_interface" "poc-nic" {
#   name                = "poc-vm-nic"
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   location            = azurerm_resource_group.msc-rg.location
# 
#   ip_configuration {
#     name                          = "poc-vm-ipconfig"
#     subnet_id                     = azurerm_subnet.poc-subnet-1.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = "10.1.1.4"
#     primary                       = true
#     public_ip_address_id          = azurerm_public_ip.poc-vm-public-ip.id
#   }
# }