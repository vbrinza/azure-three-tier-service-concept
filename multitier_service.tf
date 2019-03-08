provider "azurerm" {
}

resource "azurerm_resource_group" "rg" {
        name = "${var.project_name}-resource-group"
        location = "${var.project_location}"
        tags = {
          environment = "${var.environment}"
        }
}

resource "azurerm_network_security_group" "sgf" {
        name = "${var.project_name}-sgf"
        location = "${azurerm_resource_group.rg.location}"
        resource_group_name = "${azurerm_resource_group.rg.name}"

        security_rule {
          name = "all_outbound"
          priority = 100
          direction = "Outbound"
          access = "Allow"
          protocol = "Tcp"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "VirtualNetwork"
          destination_address_prefix = "Internet"
        }

        security_rule {
          name = "frontend_inbound"
          priority = 110
          direction = "Inbound"
          access = "Allow"
          protocol = "Tcp"
          source_port_range = "*"
          destination_port_range = "${var.frontend_port}"
          source_address_prefix = "AzureLoadBalancer"
          destination_address_prefix = "${var.frontend_subnetwork}"
        }

        security_rule {
          name = "frontend_to_backend"
          priority = 120
          direction = "Outbound"
          access = "Allow"
          protocol = "Tcp"
          source_port_range = "*"
          destination_port_range = "${var.backend_port}"
          source_address_prefix = "${var.frontend_subnetwork}"
          destination_address_prefix = "${var.backend_subnetwork}"
        }

        security_rule {
          name = "backend_to_frontend"
          priority = 130
          direction = "Inbound"
          access = "Allow"
          protocol = "Tcp"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "${var.backend_subnetwork}"
          destination_address_prefix = "${var.frontend_subnetwork}"
        }

        security_rule {
          name = "deny_all_in"
          priority = 140
          direction = "Inbound"
          access = "Deny"
          protocol = "*"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "*"
          destination_address_prefix = "*"
        }

        security_rule {
          name = "deny_all_out"
          priority = 150
          direction = "Outbound"
          access = "Deny"
          protocol = "*"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "*"
          destination_address_prefix = "*"
        }

        tags = {
          environment = "${var.environment}"
        }
}

resource "azurerm_network_security_group" "sgb" {
        name = "${var.project_name}-sgb"
        location = "${azurerm_resource_group.rg.location}"
        resource_group_name = "${azurerm_resource_group.rg.name}"

        security_rule {
          name = "frontend_to_backend"
          priority = 100
          direction = "Inbound"
          access = "Allow"
          protocol = "Tcp"
          source_port_range = "*"
          destination_port_range = "${var.backend_port}"
          source_address_prefix = "${var.frontend_subnetwork}"
          destination_address_prefix = "${var.backend_subnetwork}"
        }

        security_rule {
          name = "deny_all_in"
          priority = 140
          direction = "Inbound"
          access = "Deny"
          protocol = "*"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "*"
          destination_address_prefix = "*"
        }

        security_rule {
          name = "deny_all_out"
          priority = 150
          direction = "Outbound"
          access = "Deny"
          protocol = "*"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "*"
          destination_address_prefix = "*"
        }

        tags = {
          environment = "${var.environment}"
        }
}

resource "azurerm_network_security_group" "sgdb" {
        name = "${var.project_name}-sgdb"
        location = "${azurerm_resource_group.rg.location}"
        resource_group_name = "${azurerm_resource_group.rg.name}"

        security_rule {
          name = "backend_to_db"
          priority = 100
          direction = "Inbound"
          access = "Allow"
          protocol = "Tcp"
          source_port_range = "*"
          destination_port_range = "${var.db_port}"
          source_address_prefix = "${var.backend_subnetwork}"
          destination_address_prefix = "${var.db_subnetwork}"
        }

        security_rule {
          name = "deny_all_in"
          priority = 120
          direction = "Inbound"
          access = "Deny"
          protocol = "*"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "*"
          destination_address_prefix = "*"
        }

        security_rule {
          name = "deny_all_out"
          priority = 130
          direction = "Outbound"
          access = "Deny"
          protocol = "*"
          source_port_range = "*"
          destination_port_range = "*"
          source_address_prefix = "*"
          destination_address_prefix = "*"
        }

        tags = {
          environment = "${var.environment}"
        }
}

resource "azurerm_virtual_network" "vn" {
        name = "${var.project_name}-vn"
        location = "${azurerm_resource_group.rg.location}"
        resource_group_name = "${azurerm_resource_group.rg.name}"
        address_space = ["${var.virtual_network}"]
        subnet = {
          name = "frontend_subnetwork"
          address_prefix = "${var.frontend_subnetwork}"
          security_group = "${azurerm_network_security_group.sgf.id}"
        }
        subnet = {
          name = "backend_subnetwork"
          address_prefix = "${var.backend_subnetwork}"
          security_group = "${azurerm_network_security_group.sgb.id}"
        }
        subnet = {
          name = "db_subnetwork"
          address_prefix = "${var.db_subnetwork}"
          security_group = "${azurerm_network_security_group.sgdb.id}"
        }
        tags = {
          environment = "${var.environment}"
        }
}
