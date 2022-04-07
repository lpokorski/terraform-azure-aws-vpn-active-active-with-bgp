# terraform-azure-aws-vpn-active-active-with-bgp

# Introduction 
These terrafrom scripts deploy full mesh Site to Site IPSEC VPN between Azure and AWS Cloud.
For detailed information refer to [Azure Documentation](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp)

## Resources

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