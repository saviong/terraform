# Terraform Multi-Cloud Deployment: AWS & Azure

This project demonstrates how to use Terraform to provision virtual machines across two major cloud providers: Amazon Web Services (AWS) and Microsoft Azure. It creates one EC2 instance on AWS and one Virtual Machine on Azure, both configured with a simple web server.

This code is designed to follow security best practices by avoiding hardcoded credentials and using SSH keys for access.

## Features

- **Multi-Cloud:** Manages resources on both AWS and Azure from a single Terraform configuration.
- **Automated Setup:** Includes `user_data` (AWS) and `custom_data` (Azure) scripts to install and run a basic web server (Nginx/Apache) on boot.
- **Organized & Modular:** The code is logically separated into different files based on function (`providers.tf`, `aws_ec2.tf`, etc.) for readability and maintainability.
> [!CAUTION]
>**Secure by Default:**
> - No hardcoded API keys, access keys, or secrets in the configuration files.
> - Uses environment variables or CLI profiles for provider authentication.
> - Provisions a new SSH key pair for secure VM access and disables password authentication.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1.  **[Terraform](https://www.terraform.io/downloads.html)** (Version 1.0 or newer)
2.  **[AWS CLI](https://aws.amazon.com/cli/)**
3.  **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
4.  **[AWS documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)**
5.  **[Azure documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)**

## Setup & Configuration

1.  **Clone the Repository:**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-directory>
    ```

2.  **Authenticate with AWS:**
    Configure your AWS credentials. The simplest way is to run:
    ```bash
    aws configure
    ```
    Enter your AWS Access Key ID, Secret Access Key, default region, and default output format when prompted. The Terraform AWS provider will use these credentials automatically.

3.  **Authenticate with Azure:**
    Log in to your Azure account using the Azure CLI:
    ```bash
    az login
    ```
    This will open a browser window for you to sign in. The Terraform Azure provider will automatically use these credentials.

## Usage

Follow the standard Terraform workflow to provision and manage the infrastructure.

1.  **Initialize the Project:**
    This command downloads the necessary provider plugins (AWS, Azure, TLS, Local).
    ```bash
    terraform init
    ```

2.  **Plan the Deployment:**
    This command shows you an execution plan of what resources Terraform will create, change, or destroy. It's a great way to review everything before applying.
    ```bash
    terraform plan
    ```

3.  **Apply the Configuration:**
    This command builds and deploys the resources defined in your `.tf` files. You will be prompted to confirm the action.
    ```bash
    terraform apply
    ```

4.  **Connect to your VMs:**
    After a successful deployment, Terraform will output the SSH commands needed to connect to your new virtual machines. A private key file named `multi-cloud-vm-key.pem` will be created in your project directory for this purpose.

5.  **Destroy the Infrastructure:**
    When you are finished, you can remove all created resources with a single command. You will be prompted to confirm the action.
    ```bash
    terraform destroy
    ```

## File Structure

The project code is organized into the following files:

-   `providers.tf`: Declares the required Terraform providers (AWS, Azure, TLS, Local) and their configurations.
-   `ssh_key.tf`: Generates an SSH key pair to be used for both the AWS and Azure VMs and saves the private key locally.
-   `aws_ec2.tf`: Defines all AWS-related resources, including the `aws_key_pair` and the `aws_instance` (EC2).
-   `azure_vm.tf`: Defines all Azure-related resources, including the resource group, networking components, and the `azurerm_linux_virtual_machine`.
-   `outputs.tf`: Specifies the data to be outputted after a successful deployment, such as the public IP addresses and the SSH commands for both VMs.


