

# Create a VPC
resource "aws_vpc" "aws-vpc" {

  cidr_block = var.aws_vnet_prefix

  tags = {
    Name = "VPC1"
  }
}


# Needed for AWS Test VM Internet connectivity
resource "aws_internet_gateway" "ig-test-aws-vm" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name = "ig-test-aws-vm"
  }
}


resource "aws_route_table" "vpn-route-table" {
  vpc_id = aws_vpc.aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-test-aws-vm.id
  }

  tags = {
    Name = "vpn-route-table"
  }
}


resource "aws_subnet" "vpn-subnet" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.aws_vm_subnet_prefix
  map_public_ip_on_launch = true

  tags = {
    Name = "vpn-test-subnet"
  }
}

resource "aws_route_table_association" "vpn-route-table-asoc" {
  subnet_id      = aws_subnet.vpn-subnet.id
  route_table_id = aws_route_table.vpn-route-table.id
}

resource "aws_vpn_gateway_route_propagation" "vpc-route-propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpn-gw.id
  route_table_id = aws_route_table.vpn-route-table.id
}

resource "aws_vpn_gateway" "vpn-gw" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name = "vpn-gw"
  }
}

resource "aws_customer_gateway" "ToAzureInstance0" {
  bgp_asn    = var.azure_vpn_gateway_asn
  ip_address = azurerm_public_ip.VNet1GWpip.ip_address
  type       = "ipsec.1"
  tags = {
    Name = "ToAzureInstance0"
  }
}

resource "aws_customer_gateway" "ToAzureInstance1" {
  bgp_asn    = var.azure_vpn_gateway_asn
  ip_address = azurerm_public_ip.VNet1GWpip2.ip_address
  type       = "ipsec.1"
  tags = {
    Name = "ToAzureInstance1"
  }
}


resource "aws_vpn_connection" "ToAzureInstance0" {
  vpn_gateway_id        = aws_vpn_gateway.vpn-gw.id
  customer_gateway_id   = aws_customer_gateway.ToAzureInstance0.id
  type                  = "ipsec.1"
  static_routes_only    = false
  tunnel1_preshared_key = random_password.AWSTunnel1ToInstance0-PSK.result
  tunnel2_preshared_key = random_password.AWSTunnel2ToInstance0-PSK.result
  tunnel1_inside_cidr   = var.bgp_apipa_cidr_1
  tunnel2_inside_cidr   = var.bgp_apipa_cidr_2
  #tunnel1_ike_versions = "ikev2"
  #tunnel2_ike_versions = "ikev2"  
  tags = {
    Name = "ToAzureInstance0"
  }
}

resource "aws_vpn_connection" "ToAzureInstance1" {
  vpn_gateway_id        = aws_vpn_gateway.vpn-gw.id
  customer_gateway_id   = aws_customer_gateway.ToAzureInstance1.id
  type                  = "ipsec.1"
  static_routes_only    = false
  tunnel1_preshared_key = random_password.AWSTunnel1ToInstance1-PSK.result
  tunnel2_preshared_key = random_password.AWSTunnel2ToInstance1-PSK.result
  tunnel1_inside_cidr   = var.bgp_apipa_cidr_3
  tunnel2_inside_cidr   = var.bgp_apipa_cidr_4
  #tunnel1_ike_versions = "ikev2"
  #tunnel2_ike_versions = "ikev2"  
  tags = {
    Name = "ToAzureInstance1"
  }
}


output "ToAzureInstance0_Tunnel1_IP" {
  description = "To AzureInstance0 Tunnel 1 Outside IP address"
  value       = aws_vpn_connection.ToAzureInstance0.tunnel1_address
}

output "ToAzureInstance0_Tunnel2_IP" {
  description = "To AzureInstance0 Tunnel 2 Outside IP address"
  value       = aws_vpn_connection.ToAzureInstance0.tunnel2_address
}


output "ToAzureInstance1_Tunnel1_IP" {
  description = "To AzureInstance2 Tunnel 1 Outside IP address"
  value       = aws_vpn_connection.ToAzureInstance1.tunnel1_address
}

output "ToAzureInstance1_Tunnel2_IP" {
  description = "To AzureInstance1 Tunnel 2 Outside IP address"
  value       = aws_vpn_connection.ToAzureInstance1.tunnel2_address
}
