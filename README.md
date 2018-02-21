## 3-tier using Softlayer Classic resources


## [Get the Terraform code](https://github.ibm.com/pbahrs/iaas_ref_architectures/tree/master/terraform/3Tier/ClassicSoftlayer)


### Softlayer Classic Implementation Architecture Diagram

   ![Burst virtual servers](https://github.ibm.com/pbahrs/iaas_ref_architectures/blob/master/imgs/SL3-tier.png)
   
### Architecture Notes  

 - [IBM Cloud](https://www.ibm.com/cloud/?S_PKG=&cm_mmc=Search_Google-_-Cloud_Cloud+Platform-_-WW_US-_-+ibm++cloud_Broad_&cm_mmca1=000016GC&cm_mmca2=10004026&cm_mmca7=9008188&cm_mmca8=aud-311016886972:kwd-301973236515&cm_mmca9=6cd5a330-083d-4bc1-b6a9-9d15e42966fb&cm_mmca10=231586021885&cm_mmca11=b&mkwid=6cd5a330-083d-4bc1-b6a9-9d15e42966fb|1150|385392&cvosrc=ppc.google.%2Bibm%20%2Bcloud&cvo_campaign=000016GC&cvo_crid=231586021885&Matchtype=b)
 
 - [Virtual Router Appliance](https://console.bluemix.net/docs/infrastructure/virtual-router-appliance/getting-started.html#getting-started)
 
 - [VLAN Spanning](https://knowledgelayer.softlayer.com/procedure/enable-or-disable-vlan-spanning)
 
 - [Data Center](https://www.ibm.com/cloud-computing/bluemix/data-centers)
 
 - [Region](https://console.bluemix.net/docs/containers/cs_regions.html#regions-and-locations)
 
 - [Public/Private VLAN](https://knowledgelayer.softlayer.com/topic/vlans)
 
 - [Virtual Server Instance](https://www.ibm.com/cloud/virtual-servers)
 
 - [Security Group](https://www.ibm.com/blogs/bluemix/2017/11/security-groups/)
 
 - [Auto-scaling Group](https://www.ibm.com/cloud/auto-scaling)
 
 - [IPSec VPN](https://www.ibm.com/blogs/bluemix/2016/07/vpn-for-bluemix-enhancements/)
 

## Design Decisions
| Design item                | Decision|
| :----------------------------------- | :--------------------------------------------------------------------------------|
|Code organization|Used modules for each primary resource|
|Single/multi-tenant hosts|The configuration file suports multi-tenant host deployments. To deploy as a single tenant, set the variable 'dedicated_acct_host_only" to "true" and include the host name.|
|Number of VSIs to deploy|The configuration file supports two virtual servers in the initial auto-scaling group.|
|Option to reuse existing VLAN|Included the "count" variable in the block to deploy the private VLAN. Also used the "replace" function to determine the value of the "public_vlan_id" in the "ibm_compute_vm_instance". The nested replace call returns the deployed vlan id when the vlan count is set to 1 and returns the vlanid variable when the count is set to 0.  ${replace(replace(var.vlan_count, "1", ibm_network_vlan.vlan_burst.id), "0", var.vlanid)} |
|Local disk |Two SAN storage volumes for each VSI.|
|Storage|A common file storage for web tier. A common file, block, object for app tier.|
|Data services|Used IBM Cloudant data service.|
|Security|A single, common security group for all VSIs in each of the two tiers. No firewall was used.|
|SSH keys|Used a single, common key for all VSIs in each tier.|
|Hostnaming|Used a naming convention that includes standard naming convention and adds the "count" value to the end of the name. ${format("burstvs-%02d", count.index + 1)} |
|Limits on number of VSIs|Check with Softlayer capavbilities to understand the maximum numbers of VSIs that can be enterd into the count variable value| 
