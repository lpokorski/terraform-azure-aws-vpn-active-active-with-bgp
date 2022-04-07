# terraform-azure-aws-vpn-active-active-with-bgp

## Introduction 
These terrafrom scripts deploy full mesh Site to Site IPSEC VPN between Azure and AWS Cloud.
For detailed information refer to [Azure Documentation](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp)

## Resources
### Azure Resources

Below Table represents resources which terraform creates in Azure


| Type | Name| Description| TF file|
|------|------|------|:--------:|
| [Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | VNet1 | Azure Virtual Network | main.tf
| [Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | TestRG1 | Azure RFesource Group where all deployed Azure resources whill be placed| s2s-vpn-azure.tf|
| [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | GatewaySubnet | Subnet where Azure Network Gateway will be placed| s2s-vpn-azure.tf|
| [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | VNet1GWpip | Azure Public IP which will be associated to VPN Network Gateway Instance0| s2s-vpn-azure.tf|
| [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | VNet1GWpip2 | Azure Public IP which will be associated to VPN Network Gateway Instance1| s2s-vpn-azure.tf|
| [Azure Virtual Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | VNet1GW | Azure Virtual Network Gateway| s2s-vpn-azure.tf|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | AWSTunnel1ToInstance0 | Azure Local Network Gateway - AWS Connection1 Tunnel1| s2s-vpn-azure.tf|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | AWSTunnel2ToInstance0 | Azure Local Network Gateway - AWS Connection1 Tunnel2| s2s-vpn-azure.tf|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gatewayp) | AWSTunnel1ToInstance1 | Azure Local Network Gateway - AWS Connection2 Tunnel1| s2s-vpn-azure.tf|
| [Azure Local Network Gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | AWSTunnel2ToInstance01 | Azure Local Network Gateway - AWS Connection2 Tunnel2| s2s-vpn-azure.tf|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel1ToInstance0| Azure VPN connection between Azure VPN Instance0 and AWS Connection1 Tunnel1| s2s-vpn-azure.tf|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel2ToInstance0| Azure VPN connection between Azure VPN Instance0 and AWS Connection1 Tunnel2| s2s-vpn-azure.tf|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel1ToInstance1| Azure VPN connection between Azure VPN Instance1 and AWS Connection2 Tunnel1| s2s-vpn-azure.tf|
| [Connection ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | AWSTunnel2ToInstance1| Azure VPN connection between Azure VPN Instance0 and AWS Connection2 Tunnel2| s2s-vpn-azure.tf|
| [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | vm-subnet | Subnet where Azure Testing VM will be placed| vm-test-azure.tf|
| [Azure Security Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_network_security_group") | nsg-test-azure-vm | Security group which will be assigned to Azure Test VM nic which allows SSH and ICMP trafic| vm-test-azure.tf|
| [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | pip-test-azure-vm | Azure Public IP which will be associated to Azure Test VM| vm-test-azure.tf|
| [Azure Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_network_interface) | nic-test-azure-vm | Azure Network Interface will be associated to Azure Test VM| vm-test-azure.tf
| [Azure Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_linux_virtual_machine) | vpn-test-azure-vm | Azure VM for VPN connectivity testing| vm-test-azure.tf|


### AWS Resources



## Inputs

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
