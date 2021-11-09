data "aws_ami" "ami_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#create ec2
resource "aws_instance" "web_ec2" {
  ami             = data.aws_ami.ami_amazon_linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.sg_name]
  
  tags = var.ec2_tag

#provisioner local: creer file and copy public_ip
provisioner "local-exec" {
    command = "echo ${aws_instance.web_ec2.public_ip} >> ip_ec2.txt"
  }

#provisioner remote(distant):install and start nginx after creating our vm
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_path)
    host        = self.public_ip
    timeout     = "30s"
  }

  root_block_device {
    delete_on_termination = true
  }
}
