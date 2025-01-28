resource "aws_security_group" "service" {
  name   = "service"
  vpc_id = aws_vpc.service.id
}

resource "aws_vpc_security_group_ingress_rule" "service_https" {
  security_group_id = aws_security_group.service.id

  description = "HTTPS from Service VPC"
  cidr_ipv4   = aws_vpc.service.cidr_block
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "service_http" {
  security_group_id = aws_security_group.service.id

  description = "HTTP from Service VPC"
  cidr_ipv4   = aws_vpc.service.cidr_block
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "service_all" {
  security_group_id = aws_security_group.service.id

  description = "Allow all egress"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
data "aws_ami" "amazon_linux_2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

