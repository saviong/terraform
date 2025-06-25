# For terraform 0.13 and later
# The cloud providers (AWS, Azure) are used and An SSH key (TLS) is generated and saved it locally.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# AWS Configuration
# For this to work, configure your credentials using one of these methods:
# 1. Install AWS CLI and run `aws configure` in the terminal before using Terraform.
# 2. Set environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
provider "aws" {
  region = "us-east-1" # You can change this to your preferred AWS region
}

# Azure Configuration
# For this to work, configure your credentials using one of these methods:
# 1. Install Azure CLI and run `az login` in the terminal before using Terraform.
# 2. Set environment variables for a Service Principal:
#    - ARM_CLIENT_ID
#    - ARM_CLIENT_SECRET
#    - ARM_SUBSCRIPTION_ID
#    - ARM_TENANT_ID
provider "azurerm" {
  features {}
}
