This Terraform model includes the multi-cloud deployment of virtual machines in both AWS and Azure.

We leave the provider block mostly empty, Terraofrm will automatically use credentials from the environment.

SSH Key (TLS) is generated and saved it locally.

The project directory is as following:
terraform-multi-cloud/
├── providers.tf
├── ssh_key.tf
├── aws_ec2.tf
├── azure_vm.tf
└── outputs.tf
