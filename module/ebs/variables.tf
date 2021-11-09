
variable "ebs_availability_zone" {
  type = string
}

variable "ebs_size" {
  type = number
}

variable "ebs_tag" {
  type = map(any)
}