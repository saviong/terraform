# This file generates a single SSH key pair to securely access both Azure VM and AWS EC2 instance.
# Uses the tls provider to create a new RSA private key.
# Save the private key locally

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "multi-cloud-vm-key.pem"
  file_permission = "0600" # Set file permissions for security
}
