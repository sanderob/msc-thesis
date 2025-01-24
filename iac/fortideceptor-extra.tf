resource "azurerm_public_ip" "fortideceptor-public-ip-extra" {
  name                = "fortideceptor-public-ip"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
}

resource "azurerm_network_interface" "fortideceptor-management-nic-extra" {
  name                = "fortideceptor-management-nic-extra"
  resource_group_name = azurerm_resource_group.msc-rg.name
  location            = azurerm_resource_group.msc-rg.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.fortideceptor-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.fortideceptor-public-ip-extra.id
  }
}

resource "azurerm_network_interface" "fortideceptor-decoy-nic-extra" {
  name                = "fortideceptor-decoy-nic-1-extra"
  resource_group_name = azurerm_resource_group.msc-rg.name
  location            = azurerm_resource_group.msc-rg.location

  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.decoy-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "fortideceptor-data-disk-extra" {
  name                 = "fortideceptor-data-disk-0"
  resource_group_name  = azurerm_resource_group.msc-rg.name
  location             = azurerm_resource_group.msc-rg.location
  create_option        = "Empty"
  storage_account_type = "StandardSSD_LRS"
  disk_size_gb         = 1024
}

resource "azurerm_linux_virtual_machine" "fortideceptor-vm-extra" {
  name                = "fortideceptor-533"
  resource_group_name = azurerm_resource_group.msc-rg.name
  location            = azurerm_resource_group.msc-rg.location
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.fortideceptor-management-nic-extra.id,
    azurerm_network_interface.fortideceptor-decoy-nic-extra.id
  ]

  admin_username                  = "fortideceptor"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "fortideceptor"
    public_key = file("./sshkeys/sander-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 100
    name                 = "fortideceptor-os-disk-extra"
  }

  boot_diagnostics {
    storage_account_uri = "https://mscprodst.blob.core.windows.net/"
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_id = "/subscriptions/d1bbe07c-713a-4149-8c8e-313060b62dd0/resourceGroups/msc-prod-rg/providers/Microsoft.Compute/images/fortideceptor-533"
}

resource "azurerm_virtual_machine_data_disk_attachment" "fortideceptor-data-disk-attachment-extra" {
  managed_disk_id    = azurerm_managed_disk.fortideceptor-data-disk-extra.id
  virtual_machine_id = azurerm_linux_virtual_machine.fortideceptor-vm-extra.id
  lun                = 0
  caching            = "ReadWrite"
  create_option      = "Attach"
}