# resource "azurerm_network_interface" "fortideceptor-management-nic" {
#   name                = "fortideceptor-management-nic"
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   location            = azurerm_resource_group.msc-rg.location
# 
#   ip_configuration {
#     name                          = "management"
#     subnet_id                     = azurerm_subnet.fortideceptor-subnet.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = "10.0.1.4"
#     primary                       = true
#     public_ip_address_id          = azurerm_public_ip.fortideceptor-public-ip.id
#   }
# }
# 
# resource "azurerm_network_interface" "fortideceptor-decoy-nic" {
#   name                = "fortideceptor-decoy-nic-1"
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   location            = azurerm_resource_group.msc-rg.location
# 
#   ip_configuration {
#     name                          = "decoy-1"
#     subnet_id                     = azurerm_subnet.decoy-subnet.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = "10.0.2.4"
#     primary                       = true
#   }
# 
#   ip_configuration {
#     name                          = "decoy-2"
#     subnet_id                     = azurerm_subnet.decoy-subnet.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = "10.0.2.11"
#     primary                       = false
#   }
# }
# 
# resource "azurerm_managed_disk" "fortideceptor-data-disk" {
#   name                 = "fortideceptor-data-disk-0"
#   resource_group_name  = azurerm_resource_group.msc-rg.name
#   location             = azurerm_resource_group.msc-rg.location
#   create_option        = "Empty"
#   storage_account_type = "StandardSSD_LRS"
#   disk_size_gb         = 1024
# }
# 
# resource "azurerm_linux_virtual_machine" "fortideceptor-vm" {
#   name                = "fortideceptor"
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   location            = azurerm_resource_group.msc-rg.location
#   size                = "Standard_B2s"
# 
#   network_interface_ids = [
#     azurerm_network_interface.fortideceptor-management-nic.id,
#     azurerm_network_interface.fortideceptor-decoy-nic.id
#   ]
# 
#   admin_username                  = "fortideceptor"
#   disable_password_authentication = true
# 
#   admin_ssh_key {
#     username   = "fortideceptor"
#     public_key = file("./sshkeys/sander-key.pub")
#   }
# 
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#     disk_size_gb         = 100
#     name                 = "fortideceptor-os-disk"
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
#   source_image_id = "/subscriptions/d1bbe07c-713a-4149-8c8e-313060b62dd0/resourceGroups/msc-prod-rg/providers/Microsoft.Compute/images/fortideceptor-vm-image"
# }
# 
# resource "azurerm_virtual_machine_data_disk_attachment" "fortideceptor-data-disk-attachment" {
#   managed_disk_id    = azurerm_managed_disk.fortideceptor-data-disk.id
#   virtual_machine_id = azurerm_linux_virtual_machine.fortideceptor-vm.id
#   lun                = 0
#   caching            = "ReadWrite"
#   create_option      = "Attach"
# }