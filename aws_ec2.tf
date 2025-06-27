# Create an EC2 Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key-terraform"
  public_key = tls_private_key.ssh.public_key_openssh
}

# Basic example using a data source to get the latest Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name # Associate the SSH key

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Deployed with Terraform on AWS!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name        = "WebServer-AWS-Terraform"
    Project     = "MultiCloud-Demo"
    Provisioner = "Terraform"
  }
}
