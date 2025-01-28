resource "aws_security_group" "consumer" {
  name   = "consumer"
  vpc_id = aws_vpc.consumer.id
}

resource "aws_vpc_security_group_ingress_rule" "consumer_ssh" {
  security_group_id = aws_security_group.consumer.id

  description = "SSH from the internet"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "consumer_all" {
  security_group_id = aws_security_group.consumer.id

  description = "Allow all egress"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

