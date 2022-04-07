
variable "azure_tenant" {
  description = "Azure Tenant"
  type        = string
  default     = "1dfd8600-97de-4250-8886-f30a219194cf"
}

variable "azure_subscription" {
  description = "Azure subscription"
  type        = string
  default     = "86b61252-9a24-4154-b3a0-c029ad94626e"
}

variable "azure_location" {
  description = "Deployment Prefix"
  type        = string
  default     = "eastus"
}

variable "azure_zones" {
  description = "Azure Deployment Zones"
  type        = list(any)
  default     = ["1", "2", "3"]
}

variable "azure_vnet_prefix" {
  description = "Azure VNET prefix"
  type        = list(any)
  default     = ["10.1.0.0/16"]
}

variable "azure_gateway_subnet_prefix" {
  description = "GatewaySubnet Prefix"
  type        = list(any)
  default     = ["10.1.0.0/24"]
}

variable "azure_vm_subnet_prefix" {
  description = "Azure Test VM Subnet Prefix"
  type        = list(any)
  default     = ["10.1.100.0/24"]
}

variable "azure_vpn_gateway_sku" {
  description = "Azure Gateway SKU"
  type        = string
  default     = "VpnGw1AZ"
}

variable "azure_vpn_gateway_asn" {
  description = "Azure Gateway BGP ASN"
  type        = string
  default     = "65515"
}


variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}


variable "aws_vnet_prefix" {
  description = "AWS VPC1 prefix"
  type        = string
  default     = "10.2.0.0/16"
}


variable "aws_vm_subnet_prefix" {
  description = "AWS Test VM Subnet Prefix"
  type        = string
  default     = "10.2.2.0/24"
}

variable "aws_vpn_gateway_asn" {
  description = "AWS Gateway BGP ASN"
  type        = string
  default     = "64512"
}


variable "bgp_apipa_cidr_1" {
  description = "BGP APIPA CIDR 1 - AWS Tunnel 1 to Azure Instance 0"
  type        = string
  default     = "169.254.21.0/30"
}

variable "bgp_apipa_cidr_2" {
  description = "BGP APIPA CIDR 2 - AWS Tunnel 2 to Azure Instance 0"
  type        = string
  default     = "169.254.22.0/30"
}

variable "bgp_apipa_cidr_3" {
  description = "BGP APIPA CIDR 1 - AWS Tunnel 1 to Azure Instance 1"
  type        = string
  default     = "169.254.21.4/30"
}

variable "bgp_apipa_cidr_4" {
  description = "BGP APIPA CIDR 2 - AWS Tunnel 2 to Azure Instance 1"
  type        = string
  default     = "169.254.22.4/30"
}


variable ipsec_policy {
  type = object({
    dh_group        = string
    ike_encryption   = string
    ike_integrity    = string
    ipsec_encryption = string
    ipsec_integrity  = string
    pfs_group        = string
    sa_datasize      = string
    sa_lifetime      = string
  })

  default = {
    dh_group        = "ECP384"
    ike_encryption   = "GCMAES256"
    ike_integrity    = "SHA384"
    ipsec_encryption = "GCMAES256"
    ipsec_integrity  = "GCMAES256"
    pfs_group        = "ECP384"
    sa_datasize      = "102400000"
    sa_lifetime      = "27000"

  }
}

