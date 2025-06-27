# Outputs display useful information after deployment.
# The file is not compulsory required for the deployment to happen but it is the best practice to make your infrastructure much easier to use and manage.

# Get the public IP address of new EC2 without finding it via the portal
output "aws_ec2_public_ip" {
  description = "Public IP address of the AWS EC2 instance."
  value       = aws_instance.web_server.public_ip
}

output "aws_ssh_command" {
  description = "Command to SSH into the AWS EC2 instance. The private key is saved as 'multi-cloud-vm-key.pem'."
  value       = "ssh -i ${local_file.ssh_private_key.filename} ubuntu@${aws_instance.web_server.public_ip}"
}

# Get the public IP address of new VM without finding it via the portal
output "azure_vm_public_ip" {
  description = "Public IP address of the Azure VM."
  value       = azurerm_public_ip.public_ip.ip_address
}

output "azure_ssh_command" {
  description = "Command to SSH into the Azure VM. The private key is saved as 'multi-cloud-vm-key.pem'."
  value       = "ssh -i ${local_file.ssh_private_key.filename} azureuser@${azurerm_public_ip.public_ip.ip_address}"
}
