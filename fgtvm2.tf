// FGTVM instance

resource "aws_network_interface" "eth0-2" {
  description = "fgtvm2-port1"
  private_ips = var.fgt2port1ip
  subnet_id   = aws_subnet.publicsubnetaz2.id
}
resource "aws_network_interface" "eth1-2" {
  description       = "fgtvm2-port2"
  subnet_id         = aws_subnet.privatesubnetaz2.id
  private_ips       = var.fgt2port2ip
  source_dest_check = false
}
resource "aws_network_interface" "eth2-2" {
  description       = "fgtvm2-port3"
  subnet_id         = aws_subnet.hasyncsubnetaz2.id
  private_ips       = var.fgt2port3ip
  source_dest_check = false
}

data "aws_network_interface" "eth1-2" {
  id = aws_network_interface.eth1-2.id
}

data "aws_network_interface" "eth2-2" {
  id = aws_network_interface.eth2-2.id
}

resource "aws_network_interface_sg_attachment" "publicattachment-2" {
  depends_on           = [aws_network_interface.eth0-2]
  security_group_id    = aws_security_group.public_allow.id
  network_interface_id = aws_network_interface.eth0-2.id
}

resource "aws_network_interface_sg_attachment" "internalattachment-2" {
  depends_on           = [aws_network_interface.eth1-2]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth1-2.id
}

resource "aws_network_interface_sg_attachment" "hasyncattachment-2" {
  depends_on           = [aws_network_interface.eth2-2]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth2-2.id
}

resource "aws_instance" "fgtvm2" {
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = var.fgtami[var.region][var.arch][var.license_type]
  instance_type     = var.size
  availability_zone = var.az2
  key_name          = var.keyname
  user_data = jsonencode({
    bucket  = aws_s3_bucket.s3_bucket.id,
    region  = var.region,
    license = var.licenses[1],
    config = "/fgtvm2.conf"
  })

  iam_instance_profile = aws_iam_instance_profile.fortigate.id

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.eth0-2.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eth1-2.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.eth2-2.id
    device_index         = 2
  }

  tags = {
    Name = "FortiGateVM-2"
  }
}
