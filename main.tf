resource "aws_security_group" "web_sg" {
  name        = "lokesh-web-sg"
  description = "Security Group Created by Lokesh"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "Lokesh-Web-SG"
    Created_By = "Lokesh"
  }
}

resource "aws_instance" "webserver" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Terraform AWS Project</title>
</head>
<body style="text-align:center;font-family:Arial;margin-top:80px;">
<h1>Terraform AWS Project</h1>
<h2>Created by Lokesh</h2>
<p>EC2 Instance deployed successfully using Terraform.</p>
</body>
</html>
HTML
EOF

  tags = {
    Name       = "Lokesh-WebServer"
    Created_By = "Lokesh"
  }
}