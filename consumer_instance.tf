resource "aws_instance" "consumer" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.consumer[0].id
  vpc_security_group_ids = [aws_security_group.consumer.id]

  key_name = var.key_name

  tags = {
    Name = "PrivateLink Demo Consumer"
  }
}

