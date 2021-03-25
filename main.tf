resource "random_id" "server" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg" {
   name     = "${var.rg}-${random_id.server.hex}"
  location  = var.region
}

resource "azurerm_storage_account" "stor" {
  name                     = "stor${random_id.server.hex}"
  location                 = var.region
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
}

resource "azurerm_availability_set" "avset" {
  name                         = "avset${random_id.server.hex}"
  location                     = var.region
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "lbpip" {
  name                = "${random_id.server.hex}-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "lb${random_id.server.hex}"
}

resource "azurerm_virtual_network" "network" {
  name                = "${random_id.server.hex}${var.network}"
  location            = var.region
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet${random_id.server.hex}.${var.subnet}"
  virtual_network_name = azurerm_virtual_network.network.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = var.subnet_prefix
}

resource "azurerm_lb" "lb" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "lb${random_id.server.hex}"
  location            = var.region

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackendPool${random_id.server.hex}"
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule${random_id.server.hex}"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.lb_probe.id
  depends_on                     = [azurerm_lb_probe.lb_probe]
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "tcpProbe${random_id.server.hex}"
  protocol            = "tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = var.vm_count_per_subnet
}

resource "azurerm_network_interface" "nic" {
  name                = "nic${count.index}${random_id.server.hex}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  count               = var.vm_count_per_subnet

  ip_configuration {
    name                                    = "ipconfig${count.index}${random_id.server.hex}"
    subnet_id                               = azurerm_subnet.subnet.id
    private_ip_address_allocation           = "Dynamic"
    
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "vm${count.index}${random_id.server.hex}"
  location              = var.region
  resource_group_name   = azurerm_resource_group.rg.name
  availability_set_id   = azurerm_availability_set.avset.id
  vm_size               = var.vm_size
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  count                 = var.vm_count_per_subnet

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name          = "osdisk${count.index}${random_id.server.hex}"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
  }
  tags = {
    environment = "staging"
   
  }

}
