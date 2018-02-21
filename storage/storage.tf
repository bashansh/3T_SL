# STORAGE.tf
# This module deploys the storage services for the architecture
# file storage for web and app tiers
# block storage for app and data tiers

#################################################
# File Storage
#################################################

resource "ibm_storage_file" "webtierfile" {
  type = "Performance"
  datacenter = "${var.datacenter}"
  capacity = "20"
  iops = "100"
}

resource "ibm_storage_file" "apptierfile" {
  type = "Performance"
  datacenter = "${var.datacenter}"
  capacity = "20"
  iops = "100"
}

#################################################
# Block Storage
#################################################

resource "ibm_storage_block" "apptierblock" {
        type = "Performance"
        datacenter = "${var.datacenter}"
        capacity = 20
        iops = 100
        os_format_type = "Linux"
}
resource "ibm_storage_block" "datatierblock" {
        type = "Performance"
        datacenter = "${var.datacenter}"
        capacity = 20
        iops = 100
        os_format_type = "Linux"
}

################################################
# Output variables
################################################
output "webfileid" {
  value = "${ibm_storage_file.webtierfile.id}"
}
output "appfileid" {
  value = "${ibm_storage_file.apptierfile.id}"
}
output "appblockid" {
  value = "${ibm_storage_block.apptierblock.id}"
}
output "datablockid" {
  value = "${ibm_storage_block.datatierblock.id}"
}
