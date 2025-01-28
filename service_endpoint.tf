resource "aws_vpc_endpoint_service" "service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.service_nlb.arn]
}

resource "aws_vpc_endpoint_service_allowed_principal" "allowed_aws_accounts" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.service.id
  principal_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}
