resource "aws_ebs_volume" "ebs_amandine" {
  availability_zone = var.ebs_availability_zone
  size              = var.ebs_size

  tags = var.ebs_tag
}