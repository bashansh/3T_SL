#  MODULE 1 - Networks
# This is the network module used when you must provision the networks in your architecture
#this is the "vlan module" and all outputs are defined as ${module.vlan."reosurceid"."outputproperty"}


####################################################
# Create the public VLAN and subnet
# for the web tier
####################################################
resource "ibm_network_vlan" "vlan_public" {
   name = "3tier_public"
   datacenter = "${var.datacenter}"
   type = "PUBLIC"
   subnet_size = 8
   router_hostname = "${var.public_router}"
}
resource "ibm_subnet" "public_subnet" {
  type = "Portable"
  private = false
  ip_version = 4
  capacity = 8
  vlan_id = "${ibm_network_vlan.vlan_public.id}"
  notes = "portable_public_subnet"
}

####################################################
# Create the private VLAN and two subnets
# for the app tier
####################################################

resource "ibm_network_vlan" "vlan_private" {
   name = "3tier_private"
   datacenter = "${var.datacenter}"
   type = "PRIVATE"
   subnet_size = 8
   router_hostname = "${var.private_router}"
}

resource "ibm_subnet" "apptier_subnet1" {
  type = "Portable"
  private = true
  ip_version = 4
  capacity = 8
  vlan_id = "${ibm_network_vlan.vlan_private.id}"
  notes = "portable_private_web__subnet"
}

resource "ibm_subnet" "apptier_subnet2" {
  type = "Portable"
  private = true
  ip_version = 4
  capacity = 8
  vlan_id = "${ibm_network_vlan.vlan_private.id}"
  notes = "portable_private_APP__subnet"
}

##################################################
# variables
##################################################

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
##################################################
# outputs
##################################################
output "vlan_datacenter" {
  value = ["${var.datacenter}"]
}
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
