# Webserver instance (will also control EFS files)
resource "aws_instance" "webserver-1" {
  depends_on = [
    aws_key_pair.webserver_key,
    aws_security_group.webserver_sg
  ]
  ami                    = "ami-052c08d70def0ac62"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.webserver_key.key_name
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = "webserver"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    port        = 22
    private_key = tls_private_key.webserver_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git php -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}

# Webserver instance (will just connect and use EFS)
resource "aws_instance" "webserver-2" {
  ami                    = "ami-052c08d70def0ac62"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.webserver_key.key_name
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = "webserver"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    port        = 22
    private_key = tls_private_key.webserver_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git php -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}