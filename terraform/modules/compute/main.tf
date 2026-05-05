variable "project_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "key_name" {}

resource "aws_security_group" "agenda_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "agenda_server" {
  ami           = "ami-0c101f26f147fa7fd" # Amazon Linux 2023
  instance_type = "t3.micro"
  key_name      = var.key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.agenda_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              sudo dnf install -y docker-compose-plugin
              EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}

output "public_ip" {
  value = aws_instance.agenda_server.public_ip
}
