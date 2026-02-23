data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "frontend" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = var.instance_type_frontend
  subnet_id                     = var.frontend_subnet_id
  vpc_security_group_ids        = [var.frontend_sg_id]
  key_name                      = var.ssh_key_name
  associate_public_ip_address   = true

  tags = {
    Name    = "${var.project_name}-frontend"
    Role    = "frontend"
    Project = var.project_name
  }
}

resource "aws_instance" "backend" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = var.instance_type_backend
  subnet_id                     = var.backend_subnet_id
  vpc_security_group_ids        = [var.backend_sg_id]
  key_name                      = var.ssh_key_name

  tags = {
    Name    = "${var.project_name}-backend"
    Role    = "backend"
    Project = var.project_name
  }
}