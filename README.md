# terraform-azure-aws-vpn-active-active-with-bgp

## Introduction 
These terrafrom scripts deploy full mesh Site to Site IPSEC VPN with BGP between Azure and AWS Cloud.<br>
For detailed information refer to [Azure Documentation](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp). <br>

In addition terraform scripts deploy also Virtual Machines (one on Azure Site and one on AWS site) which could be used for connectivity testing over VPN connections.  

<img src="https://docs.microsoft.com/en-us/azure/vpn-gateway/media/vpn-gateway-howto-aws-bgp/architecture.png?raw=true" width="800" height="600">

## Resources
Note that this example creates resources in Azure and AWS cloud which can cost money. Run terraform destroy when you don't need these resources.
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
| [AWS Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | vpn-test-sg| Network Security Group for AWS Test VM| [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf)|
| [AWS SSH Key Pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | vpn-test-key-pair| SSH Key Pair for AWS Test VM | [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf)|
| [AWS EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | vpn-test-aws-vm | AWS Test VM Instance | [s2s-vpn-aws.tf](https://github.com/lpokorski/terraform-azure-aws-vpn-active-active-with-bgp/blob/main/vm-test-aws.tf)|

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
Below table represents terraform output variables.

| Name | Description | 
|------|:--------:|
| AzureInstance0_IP | Azure Network Gateway Instance0 Public IP |
| AzureInstance1_IP | Azure Network Gateway Instance1 Public IP |
| ToAzureInstance0_Tunnel1_IP | AWS To AzureInstance0 Tunnel 1 Outside IP address |
| ToAzureInstance0_Tunnel2_IP | AWS To AzureInstance0 Tunnel 2 Outside IP address |
| ToAzureInstance1_Tunnel1_IP | AWS To AzureInstance1 Tunnel 1 Outside IP address |
| ToAzureInstance1_Tunnel2_IP | AWS To AzureInstance1 Tunnel 2 Outside IP address |
| My_Public_IP | Terraform deployment Public IP |


## VPN Site-to-Site pre-shared keys
Terraform generates VPN connections pre-shared keys on the fly by using terraform [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) resources.

```hcl 
resource "random_password" "AWSTunnel1ToInstance0-PSK" {
  length  = 16
  special = false
}

resource "random_password" "AWSTunnel2ToInstance0-PSK" {
  length  = 16
  special = false
}

resource "random_password" "AWSTunnel1ToInstance1-PSK" {
  length  = 16
  special = false
}

resource "random_password" "AWSTunnel2ToInstance1-PSK" {
  length  = 16
  special = false
}
```
## Testing Virtual Machines
Terraform scripts deploy Virtual Machines (one on Azure Site and one on AWS site) which could be used for connectivity testing over VPN connections.

### SSH Public Key
Each of testing Virtual Machine requires to use ssh keys for SSH connection. Before deploying terrform scripts include your public ssh key into terraform variable "ssh_publiv_key".

### Security Groups
Communication to testing VM is restricted by Security Groups.<br>
SSH connection to Virtual Machines is allowed only from IP address where tf scrips are executed. Public deployment IP address is automatically obtained by terraform [http data-source](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http).

```hcl 
data "http" "source_ip" {
  url = "https://ifconfig.me"
}
```
For VPN testing purposes IMCP traffic is allowed between Azure VNET and AWS VPC CIDR.  


Security Group Rules for Azure Testing VM

```hcl 
resource "azurerm_network_security_rule" "nsg-test-azure-vm-rule-1" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${data.http.source_ip.body}/32"
  destination_address_prefix  = "*"
  description                 = "Test-SSH."
  resource_group_name         = azurerm_resource_group.vpn-rg.name
  network_security_group_name = azurerm_network_security_group.nsg-test-azure-vm.name
}

resource "azurerm_network_security_rule" "nsg-test-azure-vm-rule-2" {
  name                        = "icmp"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.aws_vnet_prefix
  destination_address_prefix  = "*"
  description                 = "Test-ICMP"
  resource_group_name         = azurerm_resource_group.vpn-rg.name
  network_security_group_name = azurerm_network_security_group.nsg-test-azure-vm.name
}
```

Security Group Rules for AWS Testing VM

```hcl 
resource "aws_security_group" "vpn-test-sg" {
  name        = "vpn-test-sg"
  description = "Security Group For testing vpn connectivity"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.source_ip.body}/32"]
  }

  ingress {
    description = "ICMP into VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.azure_vnet_prefix
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-test-sg"
  }
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.63 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.2 |

## Modules

No modules.
