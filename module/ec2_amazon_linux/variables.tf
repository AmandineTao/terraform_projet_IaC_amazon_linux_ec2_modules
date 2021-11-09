variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_tag" {
  type = map(any)
}

variable "key_name" {
  type = string
  description = "key_pairs name"
}

variable "sg_name" {
  type = string
}

variable "key_path" {
  type = string
  description = "path to private key for ssh connexion"
}
