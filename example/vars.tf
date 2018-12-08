
variable "vnetAddressPrefix" {
	description	=	"Address prefix"
	type	=	"string"
	default	=	"10.115.16.0/21"
}
variable "subnet2Prefix" {
	description	=	"Subnet 2 Prefix"
	type	=	"string"
	default	=	"10.115.18.0/23"
}
variable "subnet3Name" {
	description	=	"Subnet 3 Name"
	type	=	"string"
	default	=	"frontend"
}
variable "subnet1Name" {
	description	=	"Subnet 1 Name"
	type	=	"string"
	default	=	"backend"
}
variable "dnsServers" {
	type	=	"list"
	default	=	["8.8.8.8", "8.8.4.4"]
}
variable "subnet1Prefix" {
	description	=	"Subnet 1 Prefix"
	type	=	"string"
	default	=	"10.115.16.0/23"
}
variable "subnet4Prefix" {
	description	=	"Subnet 4 Prefix"
	type	=	"string"
	default	=	"10.115.22.0/28"
}
variable "subnet2Name" {
	description	=	"Subnet 2 Name"
	type	=	"string"
	default	=	"application"
}
variable "vnetName" {
	description	=	"VNet name"
	type	=	"string"
	default	=	"nc-spoke-dev-vnet"
}
variable "subnet4Name" {
	description	=	"Subnet 4 Name"
	type	=	"string"
	default	=	"appgatewaysubnet"
}
variable "subnet3Prefix" {
	description	=	"Subnet 3 Prefix"
	type	=	"string"
	default	=	"10.115.20.0/23"
}
