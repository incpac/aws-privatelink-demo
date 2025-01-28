resource "aws_vpc_endpoint" "consumer_privatelink" {
  service_name       = aws_vpc_endpoint_service.service.service_name
  security_group_ids = [aws_security_group.consumer_privatelink.id]
  subnet_ids         = aws_subnet.consumer[*].id
  vpc_endpoint_type  = "Interface"
  vpc_id             = aws_vpc.consumer.id
}

resource "aws_security_group" "consumer_privatelink" {
  name   = "consumer_privatelink"
  vpc_id = aws_vpc.consumer.id
}

resource "aws_vpc_security_group_ingress_rule" "consumer_privatelink_https" {
  security_group_id = aws_security_group.consumer_privatelink.id

  description = "HTTPS from Consumer VPC"
  cidr_ipv4   = aws_vpc.consumer.cidr_block
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "consumer_privatelink_all" {
  security_group_id = aws_security_group.consumer_privatelink.id

  description = "Allow all outbound"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
