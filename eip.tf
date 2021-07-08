resource "aws_eip" "nlb_stage_ap_south_1a" {
  tags = {
    "Name" = "nlb_stage_ap_south_1a"
  }
}
resource "aws_eip" "nlb_stage_ap_south_1b" {
  tags = {
    "Name" = "nlb_stage_ap_south_1b"
  }
}

# Create NLB and map EIP to corresponding subnets (subnet_mapping)
resource "aws_lb" "network_lb" {
  name               = "${var.ProjectName}-pub-${var.env}"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = var.public_subnet_ap_south_1a
    allocation_id = aws_eip.nlb_stage_ap_south_1a.id
  }
  subnet_mapping {
    subnet_id     = var.public_subnet_ap_south_1b
    allocation_id = aws_eip.nlb_stage_ap_south_1b.id
  }
  tags = {
    Name        = "${var.ProjectName}-pub-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

#Creating TG for NLB
resource "aws_lb_target_group" "network_lb_tg_80" {
  name              = "${var.ProjectName}-tg-80-${var.env}"
  port              = 80
  protocol          = "TCP"
  target_type       = "ip"
  vpc_id            = var.vpc_id
  proxy_protocol_v2 = false
}
resource "aws_lb_listener" "nlb_listeners_80" {
  load_balancer_arn = aws_lb.network_lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network_lb_tg_80.arn
  }
}
