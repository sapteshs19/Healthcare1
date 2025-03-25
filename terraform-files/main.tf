provider "aws" {
  region     = "eu-north-1"
}

# 🔹 Create a Security Group
resource "aws_security_group" "test_sg" {
  name        = "test-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-04559e4b5e086e135"

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-sg"
  }
}

# 🔹 Create EC2 Instance
resource "aws_instance" "test-server" {
  ami                    = "ami-0c1ac8a41498c1a9c"
  instance_type          = "t3.micro"
  key_name               = "new"
  vpc_security_group_ids = [aws_security_group.test_sg.id]  # 🔹 Use created SG

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./new.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait to start the instance'"]
  }

  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

 #provisioner "local-exec" {
    #command = "ansible-playbook /var/lib/jenkins/workspace/Healthcare1/terraform-files/ansible-playbook.yml"
  #}
}
