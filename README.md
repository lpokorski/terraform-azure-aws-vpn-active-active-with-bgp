# terraform-azure-aws-vpn-active-active-with-bgp

## Introduction 
These terrafrom scripts deploy full mesh Site to Site IPSEC VPN with BGP between Azure and AWS Cloud.<br>
For detailed information refer to [Azure Documentation](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp) <br>

In addition terraform scripts deploy also Virtual Machines (one on Azure Site and one on AWS site) which could be used for connectivity testing over VPN connections.  

<img src="https://docs.microsoft.com/en-us/azure/vpn-gateway/media/vpn-gateway-howto-aws-bgp/architecture.png?raw=true" width="800" height="600">

## Resources
### Azure Resources

Below table represents resources which terraform creates in Azure Cloud


| Type | Name| Description| TF file|
|------|------|------|:--------:|
| [Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | VNet1 | Azure Virtual Network | [main.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/main.tf)
| [Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | TestRG1 | Azure RFesource Group where all deployed Azure resources whill be placed| [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | GatewaySubnet | Subnet where Azure Network Gateway will be placed|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | VNet1GWpip | Azure Public IP which will be associated to VPN Network Gateway Instance0|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | VNet1GWpip2 | Azure Public IP which will be associated to VPN Network Gateway Instance1|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Virtual Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | VNet1GW | Azure Virtual Network Gateway|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | AWSTunnel1ToInstance0 | Azure Local Network Gateway - AWS Connection1 Tunnel1|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | AWSTunnel2ToInstance0 | Azure Local Network Gateway - AWS Connection1 Tunnel2|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gatewayp) | AWSTunnel1ToInstance1 | Azure Local Network Gateway - AWS Connection2 Tunnel1|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | AWSTunnel2ToInstance01 | Azure Local Network Gateway - AWS Connection2 Tunnel2|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel1ToInstance0| Azure VPN connection between Azure VPN Instance0 and AWS Connection1 Tunnel1|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel2ToInstance0| Azure VPN connection between Azure VPN Instance0 and AWS Connection1 Tunnel2|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel1ToInstance1| Azure VPN connection between Azure VPN Instance1 and AWS Connection2 Tunnel1|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel2ToInstance1| Azure VPN connection between Azure VPN Instance0 and AWS Connection2 Tunnel2|  [s2s-vpn-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-azure.tf)|
| [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | vm-subnet | Subnet where Azure Testing VM will be placed|  [vm-test-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-azure.tf)|
| [Azure Security Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_network_security_group") | nsg-test-azure-vm | Security group which will be assigned to Azure Test VM nic which allows SSH and ICMP trafic| [vm-test-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-azure.tf)|
| [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | pip-test-azure-vm | Azure Public IP which will be associated to Azure Test VM| [vm-test-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-azure.tf)|
| [Azure Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_network_interface) | nic-test-azure-vm | Azure Network Interface will be associated to Azure Test VM| [vm-test-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-azure.tf)|
| [Azure Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_linux_virtual_machine) | vpn-test-azure-vm | Azure VM for VPN connectivity testing| [vm-test-azure.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-azure.tf)|


### AWS Resources

Below table represents resources which terraform creates in AWS Cloud.

| Type | Name| Description| TF file|
|------|------|------|:--------:|
| [AWS VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | VPC1 | AWS VPC| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|ski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-azure.tf)|
| [AWS Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | ig-test-aws-vm|AWS Internet Gateway in VPC1 - Needed by AWS testing VM|  [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS Route Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | vpn-route-table|Route Table in VPC1 |  [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS VPC Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | vpn-subnet| Subnet in VPC1 for placing AWS testing VM | [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS VPN Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | vpn-gw|AWS VPN Gateway|  [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS Customer Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) |ToAzureInstance0| AWS Customer Gateway represenmting Azure VPN Instance0|  [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS Customer Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | ToAzureInstance1| AWS Customer Gateway represenmting Azure VPN Instance1| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS VPN Connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | ToAzureInstance0| AWS VPN Connection to Azure VPN Instance0| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS VPN Connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | ToAzureInstance1| AWS VPN Connection to Azure VPN Instance1| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/s2s-vpn-aws.tf)|
| [AWS Network Interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | nic-test-aws-vm| Network Interface for AWS Test VM| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf)|
| [AWS Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | vpn-test-sg| Network Security Group for AWS Test VM| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf))|
| [AWS SSH Key Pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | vpn-test-key-pair| SSH Key Pair for AWS Test VM | [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf))|
| [AWS EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | vpn-test-aws-vm | AWS Test VM Instance | [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf))|

## Inputs
Below table represents terraform input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure_tenant | ID of Azure Tenant. | `string` | none | yes|
| azure_subscription| ID of Azure Subscription. | `string` | none | yes|
| azure_location | ID of Azure Location | `string` | none | yes|
| azure_vnet_prefix | IP Prefix for Azure VNET1 | `list(string)` | `10.1.0.0/16` | yes|
| azure_gateway_subnet_prefix | Azure Subnet GatewaySubnet IP Prefix| `list(string)` | `10.1.0.0/24` | yes|
| azure_vm_subnet_prefix| Azure Test VM Subnet IP Prefix | `list(string)` | `10.1.100.0/24` | yes|
| azure_vpn_gateway_sku| Azure Network Gateway SKU | `string` | `VpnGw1AZ`| yes|
| azure_vpn_gateway_asn| Azure Network Gateway BGP ASN | `string` | `65515`| yes|
| aws_region| AWS Region where AWS resources will be deployed| `string` | `eu-west-1`| yes|
| azure_vnet_prefix | AWS VPC1 prefix | `list(string)` | `10.2.0.0/16` | yes|
| aws_vm_subnet_prefix| AWS Test VM Subnet IP Prefix | `list(string)` | `10.2.100.0/24` | yes|
| aws_vpn_gateway_asn| AWS Gateway BGP ASN | `string` | `64512`| yes|
| bgp_apipa_cidr_1| BGP APIPA CIDR 1 - AWS Tunnel 1 to Azure Instance 0| `string` | `169.254.21.0/30`| yes|
| bgp_apipa_cidr_2| BGP APIPA CIDR 2 - AWS Tunnel 2 to Azure Instance 0| `string` | `169.254.22.0/30`| yes|
| bgp_apipa_cidr_3| BGP APIPA CIDR 3 - AWS Tunnel 1 to Azure Instance 1| `string` | `169.254.21.4/30`| yes|
| bgp_apipa_cidr_4| BGP APIPA CIDR 4 - AWS Tunnel 2 to Azure Instance 1| `string` | `169.254.22.4/30`| yes|
| ipsec_policy| IPSEC Protocols| `object`(<br>{ </br> dh_group = string </br> ike_encryption = string</br> ike_integrity = string</br>  ipsec_encryption = string</br> ipsec_integrity = string</br>pfs_group = string</br>sa_datasize = string</br>sa_lifetime = string</br> }</br>`)` | dh_group = "ECP384" </br> ike_encryption = "GCMAES256"</br> ike_integrity = "SHA384"</br>  ipsec_encryption = "GCMAES256"</br> ipsec_integrity = "GCMAES256"</br>pfs_group = "SHA384"</br>sa_datasize = "102400000"</br>sa_lifetime = "27000"</br>| yes|

## Outputs
