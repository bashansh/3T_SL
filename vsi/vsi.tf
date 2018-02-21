##############################################################################
# IBM SSH Key: For connecting to the VMs
##############################################################################
resource "ibm_compute_ssh_key" "ssh_key" {
  label                       = "${var.ssh_label}"
  notes                       = "${var.ssh_notes}"
  public_key                  = "${var.ssh_public_key}"
}

##############################################################################
# Create the web tier VMs that will be part of the LB service group
##############################################################################
resource "ibm_compute_vm_instance" "webtiervm" {
  count = "${var.vm_count}"
  os_reference_code = "${var.osrefcode}"
  hostname = "${format("webtier-%02d", count.index + 1)}"
  domain = "${var.webdomain}"
  datacenter = "${var.datacenter}"
  file_storage_ids = ["${module.storage.webfileid}"]
  network_speed = 10
  cores = 1
  memory = 1024
  local_disk = true
  ssh_key_ids = ["${ibm_compute_ssh_key.ssh_key.id}"]
  local_disk = false
  private_vlan_id = "${module.network.private_vlan_id}"
  public_vlan_id = "${module.network.public_vlan_id}"
  private_subnet = "${module.network.private_vlan_subnet1_id}"
}

##############################################################################
# Create the APP tier VMs that will be part of the LB service group
##############################################################################
resource "ibm_compute_vm_instance" "apptiervm" {
  count = "${var.vm_count}"
  os_reference_code = "${var.osrefcode}"
  hostname = "${format("apptier-%02d", count.index + 1)}"
  datacenter = "${var.datacenter}"
  file_storage_ids = ["${module.storage.appfileid}"]
  block_storage_ids = ["${module.storage.appblockid}"]
  network_speed = 10
  cores = 1
  memory = 1024
  disks = [25, 10]
  ssh_key_ids = ["${ibm_compute_ssh_key.ssh_key.id}"]
  local_disk = false
  private_vlan_id = "${module.network.private_vlan_id}"
  private_subnet = "${module.network.private_vlan_subnet2_id}"
# this is where we add the security group #
}


##############################################################################
# variables
##############################################################################
variable datacenter {
  description = "location to deploy"
  default = "dal06"
}
variable domain {
  description = "domain of the VMs"
  default = "mybluemix.com"
}
variable privatevlanid {
  description = "private VLAN"
  default = "123456"
}
variable publicvlanid {
  description = "public VLAN"
  default = "123456"
}

variable ssh_public_key {
  default = "please fill in"
}
variable ssh_label {
  default = "3-tiersshkey"
}
variable ssh_notes {
  default = "this is the 3 tier example ssh key"
}
variable node_count {
  default = "1"
}
variable osrefcode {
  default = "UBUNTU_LATEST"
}
variable vm_count {
  default = "1"
}
################################################
# Outputs
################################################
  output "app_ipaddress" {
  value = "[${ibm_compute_vm_instance.apptiervm.ip_address_id}]"
}
  output "web_ipaddress" {
  value = "[${ibm_compute_vm_instance.webtiervm.ip_address_id}]"
}
