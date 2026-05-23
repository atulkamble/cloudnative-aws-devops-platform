provider "aws" {
  region = "us-east-1"
}

# Generate key pair locally and in AWS
resource "tls_private_key" "jenkins" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content              = tls_private_key.jenkins.private_key_pem
  filename             = "${path.module}/jenkins.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins"
  public_key = tls_private_key.jenkins.public_key_openssh
}

# Security group to allow SSH, HTTP, HTTPS, and Jenkins port
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH, HTTP, HTTPS, and Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 9000
    to_port     = 9000
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

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# Launch EC2 instance and provision via SSH
resource "aws_instance" "jenkins" {
  ami                    = "ami-0bdd88bd06d16ba03" # Amazon Linux 2023
  instance_type          = "t3.large"
  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Jenkins"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git docker maven tree",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo dnf install -y java-21-amazon-corretto-devel",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
      "sudo dnf install -y jenkins",
      "sudo usermod -aG docker jenkins",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins",
      "echo 'Waiting for Jenkins to initialize...'",
      "for i in $(seq 1 24); do if sudo test -f /var/lib/jenkins/secrets/initialAdminPassword; then break; fi; echo \"Attempt $i/24 - waiting...\"; sleep 5; done",
      "echo 'Jenkins Admin Password:'",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.jenkins.private_key_pem
    host        = self.public_ip
  }
}
