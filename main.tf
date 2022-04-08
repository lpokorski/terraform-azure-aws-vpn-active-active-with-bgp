# --------------------------------------------------------------------------------------------------
# CONFIGURE TERRAFORM PROVIDERS
# --------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.azure_tenant
  subscription_id = var.azure_subscription
  features {}

}


provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------------------------------------------
# CREATE AZURE RESOURCE GROUP
# --------------------------------------------------------------------------------------------------


resource "azurerm_resource_group" "vpn-rg" {
  name     = "TestRG1"
  location = var.azure_location

}


# --------------------------------------------------------------------------------------------------
# GENERATE VPN S2S TUNNELS PRE-SHARED KEYS
# --------------------------------------------------------------------------------------------------

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


# --------------------------------------------------------------------------------------------------
# OBTAIN DEPLOYMENT IP
# --------------------------------------------------------------------------------------------------


data "http" "source_ip" {
  url = "https://ifconfig.me"
}


# --------------------------------------------------------------------------------------------------
# OUTPUTS
# --------------------------------------------------------------------------------------------------


output "My_Public_IP" {
  description = "My Pubic IP"
  value ="${data.http.source_ip.body}/32"
}

