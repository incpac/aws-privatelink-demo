resource "aws_lb" "service_alb" {
  name               = "service-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.service.id]
  subnets            = aws_subnet.service[*].id
}

resource "aws_lb_target_group" "service_alb" {
  name     = "service"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.service.id
}

resource "aws_lb_target_group_attachment" "service_alb" {
  target_group_arn = aws_lb_target_group.service_alb.arn
  target_id        = aws_instance.service.id
  port             = 80
}

resource "tls_private_key" "service" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "service" {
  private_key_pem = tls_private_key.service.private_key_pem

  subject {
    common_name  = aws_lb.service_alb.dns_name
    organization = "ACME Demos"
  }

  validity_period_hours = 72 # 3 days

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "service" {
  private_key      = tls_private_key.service.private_key_pem
  certificate_body = tls_self_signed_cert.service.cert_pem
}

resource "aws_lb_listener" "service_alb" {
  load_balancer_arn = aws_lb.service_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.service.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_alb.arn
  }
}
