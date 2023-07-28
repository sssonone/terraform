data "aws_ami" "server_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230207.0-x86_64-gp2"]
  }
}

resource "aws_instance" "terraform_test_ec2" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id
  key_name      = var.key_name
  user_data     = templatefile("userdata.tpl", {})

  tags = {
    Name = "terraform_test_ec2"
  }

  vpc_security_group_ids = [aws_security_group.terraform_test_sg.id]
  subnet_id              = aws_subnet.terraform_public_test_subnet[0].id

  root_block_device {
    volume_size = var.vol_size
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = aws_instance.terraform_test_ec2[0].availability_zone
  size              = 2
}

resource "aws_volume_attachment" "example" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.terraform_test_ec2[0].id
}

output "public_ips" {
  value = aws_instance.terraform_test_ec2[*].public_ip
}

output "key_name" {
  value = var.key_name
}





