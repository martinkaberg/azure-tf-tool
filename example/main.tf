//NOTE on Virtual Networks and Subnet's: Terraform currently provides both a standalone Subnet resource, and allows for
//Subnets to be defined in-line within the Virtual Network resource. At this time you cannot use a Virtual Network with
//in-line Subnets in conjunction with any Subnet resources. Doing so will cause a conflict of Subnet configurations and
//will overwrite Subnet's.
//https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html
provider "azurerm" {
}


variable "region" {
  type = "string"
  default = "westeurope"
}


variable "resource_group_name" {}


resource "azurerm_virtual_network" "vnet" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location = "${azurerm_resource_group.rg.location}"
  address_space = ["${var.vnetAddressPrefix}"]
  dns_servers = "${var.dnsServers}"
  name = "${var.vnetName}"
  subnet = {
    name = "${var.subnet1Name}"
    address_prefix = "${var.subnet1Prefix}"
  }
   subnet = {
    name = "${var.subnet2Name}"
    address_prefix = "${var.subnet2Prefix}"
  }
   subnet = {
    name = "${var.subnet3Name}"
    address_prefix = "${var.subnet3Prefix}"
  }
   subnet = {
    name = "${var.subnet4Name}"
    address_prefix = "${var.subnet4Prefix}"
  }
}
// Smarter way to make  many subnets
//variable "subnet_prefixes" {
//  description = "The address prefix to use for the subnet."
//  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24",]
//}
//
//variable "subnet_names" {
//  description = "A list of public subnets inside the vNet."
//  default     = ["subnet1", "subnet2", "subnet3"]
//}
//resource "azurerm_subnet" "subnet" {
//  # Lets repeat this resource for as many times as there are items subnet_names variable list
//  count = "${length(var.subnet_names)}"
//  # Here we grab the the name of the subnet from the subnet_names list depending on which subnet it is we are creating
//  name  = "${var.subnet_names[count.index]}"
//  # Here we grab the netwrk prefix from the prefix list
//  address_prefix = "${var.subnet_prefixes[count.index]}"
//  # Here we reference the recourse group we already created
//  resource_group_name = "${azurerm_resource_group.rg.name}"
//  # This is referencing the vnet above, and dependency is worked out automatically, so all the subnets we want to create will be created in serial but only after both the vnet and the
//  # resource group is created
//  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
//}

# The resource groups is created at the end of the file,  however it will be created first since the other resources depend on it
resource "azurerm_resource_group" "rg" {
  name = "${var.resource_group_name}"
  location = "${var.region}"
}


# These outputs  will provide the ID of resources created
output "vnet_id" {
  description = "The id of the newly created vNet"
  value = "${azurerm_virtual_network.vnet.id}"
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value = "${azurerm_virtual_network.vnet.name}"
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value = "${azurerm_virtual_network.vnet.location}"
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value = "${azurerm_virtual_network.vnet.address_space}"
}

output "vnet_subnets" {
  description = "The address space of the newly created vNet"
  value = "${azurerm_virtual_network.vnet.subnet}"
}



