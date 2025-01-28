resource "aws_lb" "service_nlb" {
  name                             = "service-nlb"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = false
  internal                         = true
  subnets                          = aws_subnet.service[*].id
}

resource "aws_lb_target_group" "service_nlb" {
  name        = "service-nlb"
  port        = "443"
  protocol    = "TCP"
  target_type = "alb"
  vpc_id      = aws_vpc.service.id

  health_check {
    matcher  = "200"
    path     = "/"
    port     = "443"
    protocol = "HTTPS"
  }
}

resource "aws_lb_target_group_attachment" "service_nlb" {
  port             = aws_lb_listener.service_nlb.port
  target_group_arn = aws_lb_target_group.service_nlb.arn
  target_id        = aws_lb_listener.service_alb.load_balancer_arn
}

resource "aws_lb_listener" "service_nlb" {
  load_balancer_arn = aws_lb.service_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_nlb.arn
  }
}
