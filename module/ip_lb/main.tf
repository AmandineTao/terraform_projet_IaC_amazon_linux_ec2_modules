resource "aws_eip" "lb" {
  vpc = true
  tags = var.ip_lb_tag
}


