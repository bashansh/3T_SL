# 3-tier MAIN.tf
# This file runs each of the modules
#

#####################################################
# Create Networks and subnets
#####################################################

module "network" {
  source = "${var.network_location}"
  datacenter = "${var.datacenter}"
  public_router = "${var.public_router}"
  private_router = "${var.private_router}" 
}

#####################################################
# Create security groups
#note this is not yet available in v0.5.1
#####################################################

#module "security" {
#  source = "${var.security_location}"
#  datacenter = "${var.datacenter}"
#}

#####################################################
# Create Storage
#####################################################
module "storage" {
  source = "${var.storage_location}"
  datacenter = "${var.datacenter}"
}
#####################################################
# Create webtier
#####################################################
module "webtier" {
  source = "${var.vsi_location}"
  datacenter = "${var.datacenter}"
}
#####################################################
# Create apptier
#####################################################
module "apptier" {
  source = "${var.vsi_location}"
  datacenter = "${var.datacenter}"
}
#####################################################
# Create data (service) tier
#####################################################
module "datatier" {
  source = "${var.data_location}"
  datacenter = "${var.datacenter}"
}
#####################################################
# Variables
#####################################################


variable "datacenter" {
  default = "dal13"
  description = "the data center to deploy the VLAN."
}
variable "public_router" {
  default = "fcr01a.dal13"
  description = "the router to use for the public VLAN."
}
variable "private_router" {
  default = "bcr01a.dal13"
  description = "the router to use for the private VLAN."
}
variable "network_location" {
  default = "https://github.com/bashansh/3T_SL//network"
  description = "the network module location"
}
variable "security_location" {
  default = "https://github.com/bashansh/3T_SL//security"
  description = "the security module location"
}
variable "storage_location" {
  default = "https://github.com/bashansh/3T_SL//storage"
  description = "the storage module location"
}
variable "vsi_location" {
  default = "https://github.com/bashansh/3T_SL//vsi"
  description = "the vsi module location"
}
variable "data_location" {
  default = "https://github.com/bashansh/3T_SL//data"
  description = "the data module location"
}
#####################################################
# Output reused as Variables
#####################################################

output "public_vlan_id" {
  value = "${ibm_network_vlan.vlan_public.id}"
}
output "public_vlan_subnet_id" {
  value = "${ibm_subnet.webtier_subnet.id}"
}
output "private_vlan_id" {
  value = "${ibm_network_vlan.vlan_private.id}"
}
output "private_vlan_subnet1_id" {
  value = "${ibm_subnet.apptier_subnet1.id}"
}
output "private_vlan_subnet2_id" {
  value = "${ibm_subnet.apptier_subnet2.id}"
}
