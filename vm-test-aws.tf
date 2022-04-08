data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# --------------------------------------------------------------------------------------------------
# CREATE AWS TESTING VM
# --------------------------------------------------------------------------------------------------


resource "aws_network_interface" "nic-test-aws-vm" {
  subnet_id       = aws_subnet.vpn-subnet.id
  security_groups = [aws_security_group.vpn-test-sg.id]
  tags = {
    Name = "nic-test-aws-vm"
  }
}


resource "aws_security_group" "vpn-test-sg" {
  name        = "vpn-test-sg"
  description = "Security Group For testing vpn connectivity"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.source_ip.body}/32"]
  }

  ingress {
    description = "ICMP into VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.azure_vnet_prefix
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-test-sg"
  }
}



resource "aws_key_pair" "vpn-test-key-pair" {
  key_name   = "vpn-test-key-pair"
  public_key = var.ssh_public_key
  
  tags = {
    Name = "vpn-test-key-pair"
  }
}


resource "aws_instance" "vpn-test-aws-vm" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  key_name      = "vpn-test-key-pair"

  network_interface {
    network_interface_id = aws_network_interface.nic-test-aws-vm.id
    device_index         = 0
  }

  tags = {
    Name = "vpn-test-aws-vm"
  }
}

# --------------------------------------------------------------------------------------------------
# OUTPUTS
# --------------------------------------------------------------------------------------------------
output "AWS_Test_VM_Public_IP" {
  description = "AWS Test VM Public IP"
  value = aws_instance.vpn-test-aws-vm.public_ip 
}

output "AWS_Test_VM_Private_IP" {
  description = "AWS Test VM Private IP"
  value = aws_instance.vpn-test-aws-vm.private_ip
}