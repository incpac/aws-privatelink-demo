resource "aws_instance" "service" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.service[0].id
  vpc_security_group_ids = [aws_security_group.service.id]
  user_data              = file("${path.module}/userdata.sh")

  key_name = var.key_name

  tags = {
    Name = "PrivateLink Demo Service"
  }
}

