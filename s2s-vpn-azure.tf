# --------------------------------------------------------------------------------------------------
# CREASTE AZURE VNET
# --------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "VNet1" {
  name                = "VNet1"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  address_space       = var.azure_vnet_prefix
}

resource "azurerm_subnet" "vpn-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vpn-rg.name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = var.azure_gateway_subnet_prefix
}


# --------------------------------------------------------------------------------------------------
# VPN GATEWAY PUBLIC IP
# --------------------------------------------------------------------------------------------------

resource "azurerm_public_ip" "VNet1GWpip" {
  name                = "VNet1GWpip"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "VNet1GWpip2" {
  name                = "VNet1GWpip2"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

}

# --------------------------------------------------------------------------------------------------
# VPN GATEWAY S2S
# --------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network_gateway" "VNet1GW" {
  name                = "VNet1GW"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = var.azure_vpn_gateway_sku

  ip_configuration {
    name                          = "vnetGatewayConfig-1"
    public_ip_address_id          = azurerm_public_ip.VNet1GWpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpn-subnet.id
  }

  ip_configuration {
    name                          = "vnetGatewayConfig-2"
    public_ip_address_id          = azurerm_public_ip.VNet1GWpip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpn-subnet.id
  }


  bgp_settings {
    asn = var.azure_vpn_gateway_asn

    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig-1"
      apipa_addresses       = [cidrhost(var.bgp_apipa_cidr_1, 2), cidrhost(var.bgp_apipa_cidr_2, 2)]
    }

    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig-2"
      apipa_addresses       = [cidrhost(var.bgp_apipa_cidr_3, 2), cidrhost(var.bgp_apipa_cidr_4, 2)]
    }
  }


}




# --------------------------------------------------------------------------------------------------
# LOCAL GATEWAYS
# --------------------------------------------------------------------------------------------------

resource "azurerm_local_network_gateway" "AWSTunnel1ToInstance0" {
  name                = "AWSTunnel1ToInstance0"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  gateway_address     = aws_vpn_connection.ToAzureInstance0.tunnel1_address

  bgp_settings {
    asn                 = var.aws_vpn_gateway_asn
    bgp_peering_address = cidrhost(var.bgp_apipa_cidr_1, 1)
  }
}


resource "azurerm_local_network_gateway" "AWSTunnel2ToInstance0" {
  name                = "AWSTunnel2ToInstance0"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  gateway_address     = aws_vpn_connection.ToAzureInstance0.tunnel2_address

  bgp_settings {
    asn                 = var.aws_vpn_gateway_asn
    bgp_peering_address = cidrhost(var.bgp_apipa_cidr_2, 1)
  }
}

resource "azurerm_local_network_gateway" "AWSTunnel1ToInstance1" {
  name                = "AWSTunnel1ToInstance1"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  gateway_address     = aws_vpn_connection.ToAzureInstance1.tunnel1_address

  bgp_settings {
    asn                 = var.aws_vpn_gateway_asn
    bgp_peering_address = cidrhost(var.bgp_apipa_cidr_3, 1)
  }
}


resource "azurerm_local_network_gateway" "AWSTunnel2ToInstance1" {
  name                = "AWSTunnel2ToInstance1"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.vpn-rg.name
  gateway_address     = aws_vpn_connection.ToAzureInstance1.tunnel2_address

  bgp_settings {
    asn                 = var.aws_vpn_gateway_asn
    bgp_peering_address = cidrhost(var.bgp_apipa_cidr_4, 1)
  }
}



# --------------------------------------------------------------------------------------------------
# VPN S2S CONNECTIONS
# --------------------------------------------------------------------------------------------------


resource "azurerm_virtual_network_gateway_connection" "AWSTunnel1ToInstance0" {
  name                               = "AWSTunnel1ToInstance0"
  location                           = var.azure_location
  resource_group_name                = azurerm_resource_group.vpn-rg.name
  type                               = "IPsec"
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.VNet1GW.id
  local_network_gateway_id           = azurerm_local_network_gateway.AWSTunnel1ToInstance0.id
  shared_key                         = random_password.AWSTunnel1ToInstance0-PSK.result
  enable_bgp                         = true
  connection_protocol                = "IKEv2"
  local_azure_ip_address_enabled     = false
  routing_weight                     = "0"
  use_policy_based_traffic_selectors = false
  dpd_timeout_seconds                = "45"
  express_route_gateway_bypass       = false

  ipsec_policy {
    dh_group         = var.ipsec_policy.dh_group
    ike_encryption   = var.ipsec_policy.ike_encryption
    ike_integrity    = var.ipsec_policy.ike_integrity
    ipsec_encryption = var.ipsec_policy.ipsec_encryption
    ipsec_integrity  = var.ipsec_policy.ipsec_integrity
    pfs_group        = var.ipsec_policy.pfs_group
    sa_datasize      = var.ipsec_policy.sa_datasize
    sa_lifetime      = var.ipsec_policy.sa_lifetime
  }
}

resource "azurerm_virtual_network_gateway_connection" "AWSTunnel2ToInstance0" {
  name                               = "AWSTunnel2ToInstance0"
  location                           = var.azure_location
  resource_group_name                = azurerm_resource_group.vpn-rg.name
  type                               = "IPsec"
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.VNet1GW.id
  local_network_gateway_id           = azurerm_local_network_gateway.AWSTunnel2ToInstance0.id
  shared_key                         = random_password.AWSTunnel2ToInstance0-PSK.result
  enable_bgp                         = true
  connection_protocol                = "IKEv2"
  local_azure_ip_address_enabled     = false
  routing_weight                     = "0"
  use_policy_based_traffic_selectors = false
  dpd_timeout_seconds                = "45"
  express_route_gateway_bypass       = false

  ipsec_policy {
    dh_group         = var.ipsec_policy.dh_group
    ike_encryption   = var.ipsec_policy.ike_encryption
    ike_integrity    = var.ipsec_policy.ike_integrity
    ipsec_encryption = var.ipsec_policy.ipsec_encryption
    ipsec_integrity  = var.ipsec_policy.ipsec_integrity
    pfs_group        = var.ipsec_policy.pfs_group
    sa_datasize      = var.ipsec_policy.sa_datasize
    sa_lifetime      = var.ipsec_policy.sa_lifetime
  }
}

resource "azurerm_virtual_network_gateway_connection" "AWSTunnel1ToInstance1" {
  name                               = "AWSTunnel1ToInstance1"
  location                           = var.azure_location
  resource_group_name                = azurerm_resource_group.vpn-rg.name
  type                               = "IPsec"
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.VNet1GW.id
  local_network_gateway_id           = azurerm_local_network_gateway.AWSTunnel1ToInstance1.id
  shared_key                         = random_password.AWSTunnel1ToInstance1-PSK.result
  enable_bgp                         = true
  connection_protocol                = "IKEv2"
  local_azure_ip_address_enabled     = false
  routing_weight                     = "0"
  use_policy_based_traffic_selectors = false
  dpd_timeout_seconds                = "45"
  express_route_gateway_bypass       = false

  ipsec_policy {
    dh_group         = var.ipsec_policy.dh_group
    ike_encryption   = var.ipsec_policy.ike_encryption
    ike_integrity    = var.ipsec_policy.ike_integrity
    ipsec_encryption = var.ipsec_policy.ipsec_encryption
    ipsec_integrity  = var.ipsec_policy.ipsec_integrity
    pfs_group        = var.ipsec_policy.pfs_group
    sa_datasize      = var.ipsec_policy.sa_datasize
    sa_lifetime      = var.ipsec_policy.sa_lifetime
  }
}


resource "azurerm_virtual_network_gateway_connection" "AWSTunnel2ToInstance1" {
  name                               = "AWSTunnel2ToInstance1"
  location                           = var.azure_location
  resource_group_name                = azurerm_resource_group.vpn-rg.name
  type                               = "IPsec"
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.VNet1GW.id
  local_network_gateway_id           = azurerm_local_network_gateway.AWSTunnel2ToInstance1.id
  shared_key                         = random_password.AWSTunnel2ToInstance1-PSK.result
  enable_bgp                         = true
  connection_protocol                = "IKEv2"
  local_azure_ip_address_enabled     = false
  routing_weight                     = "0"
  use_policy_based_traffic_selectors = false
  dpd_timeout_seconds                = "45"
  express_route_gateway_bypass       = false

  ipsec_policy {
    dh_group         = var.ipsec_policy.dh_group
    ike_encryption   = var.ipsec_policy.ike_encryption
    ike_integrity    = var.ipsec_policy.ike_integrity
    ipsec_encryption = var.ipsec_policy.ipsec_encryption
    ipsec_integrity  = var.ipsec_policy.ipsec_integrity
    pfs_group        = var.ipsec_policy.pfs_group
    sa_datasize      = var.ipsec_policy.sa_datasize
    sa_lifetime      = var.ipsec_policy.sa_lifetime
  }
}

# --------------------------------------------------------------------------------------------------
# OUTPUTS
# --------------------------------------------------------------------------------------------------
output "AzureInstance0_IP" {
  description = "Azure Network Gateway Instance0 Public IP"
  value       = azurerm_public_ip.VNet1GWpip.ip_address
}

output "AzureInstance1_IP" {
  description = "Azure Network Gateway Instance0 Public IP"
  value       = azurerm_public_ip.VNet1GWpip2.ip_address
}