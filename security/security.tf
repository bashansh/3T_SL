# Security module
# This module creates two security groups for web and app tier
#

##############################################
# Web tier security group
##############################################

# This is not implemented in the current 0.5.1 version. We would want to create three security groups
# sg1 = allow https port 443 to enter from the public network for the web tier
# sg2 = allows in/outbound of https on port 11443 for the web and app tier on the private VLAN
# sg3 = allows in/outbound of https on port XXXXX for web tier on private network to communicate with data service
# Here is an example based on the API capabilities

# create group
resource "ibm_security_group" "sg1" {
   name = "name of sg"
   description = "name of description"
   }
   
# add policy
resource "ibm_securitygroup_policy" "policy1" {
  securitygroupid = "${ibm_security_group.sg1.id}"
  direction = ["ingress or egress"]
  ethertype= ["ipv4, ipv6, etc"]
  remote_ip= ["169.148.34.0/24"]
  protocol= ["https, tcp, etc"]
  port_min= "port low range"
  port_max= "port high range"

##############################################
# Variables
##############################################
variable "public_port" {
  default = "443"
  description = "the port for inbound traffic to web tier servers"
}
variable "private_webapp_port" {
  default = "11443"
  description = "the port for in/out traffic between web and app tier servers"
}
variable "private_appdata_port" {
  default = "5000"
  description = "the port for in/out traffic between app tier and data service"
}

##################################################
# outputs
##################################################
output "web_sg" {
  value = ["${module.security.ibmsecuritygroup.sg1.id}"]
}
output "webapp_sg" {
  value = ["${module.security.ibmsecuritygroup.sg2.id}"]
}
output "appdata_sg" {
  value = ["${module.security.ibmsecuritygroup.sg3.id}"]
}
