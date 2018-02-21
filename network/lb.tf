# LB.tf
# Used to create the local IBM load balancer for the VMs in the web and app tiers
#

##############################################################################
# Create a local loadbalancer
##############################################################################
resource "ibm_lb" "lb" {
  connections                 = "${var.connections}"
  datacenter                  = "${var.datacenter}"
  ha_enabled                  = "${var.ha_enabled}"
  dedicated                   = "${var.dedicated}"
}

##############################################################################
# Create a service group in the loadbalancer
##############################################################################
resource "ibm_lb_service_group" "lb_service_group" {
  port                        = "${var.service_group_port}"
  routing_method              = "${var.service_group_routing_method}"
  routing_type                = "${var.service_group_routing_type}"
  load_balancer_id            = "${ibm_lb.lb.id}"
  allocation                  = "${var.service_group_allocation}"
}

##############################################################################
# Create a service
# Defines a service for each node; determines the health check,
# load balancer weight, and ip the loadbalancer will send traffic to
##############################################################################
resource "ibm_lb_service" "web_lb_service" {
  # The number of services to create, based on web node count
  count                       = "${var.vm_count}"
  # port to serve traffic on
  port                        = "${var.port}"
  enabled                     = true
  service_group_id            = "${ibm_lb_service_group.lb_service_group.service_group_id}"
  # Even distribution of traffic
  weight                      = 1
  # Uses HTTP to as a healthcheck
  health_check_type           = "HTTP"
  # Where to send traffic to
  ip_address_id               = "${element(module.network.web_ipaddress, count.index)}"
  # For demonstration purposes; creates an explicit dependency
  depends_on                  = ["ibm_compute_vm_instance.node"]
}

resource "ibm_lb_service" "app_lb_service" {
  # The number of services to create, based on web node count
  count                       = "${var.node_count}"
  # port to serve traffic on
  port                        = "${var.port}"
  enabled                     = true
  service_group_id            = "${ibm_lb_service_group.lb_service_group.service_group_id}"
  # Even distribution of traffic
  weight                      = 1
  # Uses HTTP to as a healthcheck
  health_check_type           = "HTTP"
  # Where to send traffic to
  ip_address_id               = "${element(module.network.app_ipaddress, count.index)}"
  # For demonstration purposes; creates an explicit dependency
  depends_on                  = ["module.network.web_ipaddress", "module.network.app_ipaddress"]
}

