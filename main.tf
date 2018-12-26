resource "aws_instance" "kumaradas-73721-poc-public-vms" {
  count                  = "${var.public_vm_instance_count}"
  ami                    = "ami-08419d23bf91152e4"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  subnet_id              = "${element(aws_subnet.kumaradas_73721_public_subnet.*.id,count.index % var.public_subnet_count)}"
  vpc_security_group_ids = ["${aws_security_group.kumaradas-73721-poc-allow-frm-all-IP.id}"]

  tags {
    Name   = "kumaradas-73721-poc-public-vms-${count.index}"
    Backup = "true"
  }

  connection {
    user        = "ec2-user"
    private_key = "${file(var.aws_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
    ]
  }
}

resource "aws_elb" "kumaradas-73721-poc-public-elb" {
  subnets         = ["${aws_subnet.kumaradas_73721_public_subnet.*.id}"]
  security_groups = ["${aws_security_group.kumaradas-73721-poc-allow-frm-all-IP-80.id}"]
  instances       = ["${aws_instance.kumaradas-73721-poc-public-vms.*.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  tags {
    Name = "kumaradas-73721-poc-public-elb"
  }
}

resource "aws_ebs_volume" "kumaradas_73721_ebs_volume" {
  count             = "${length(aws_instance.kumaradas-73721-poc-public-vms.*.id)}"
  availability_zone = "${element(aws_instance.kumaradas-73721-poc-public-vms.*.availability_zone,count.index)}"
  size              = "${var.kumaradas-73721-poc-public-vms_volume_size_data}"
  type              = "gp2"

  tags {
    Name   = "kumaradas_73721_ebs_volume-${count.index}"
    Backup = "true"
  }
}

resource "aws_volume_attachment" "data-ebs-volumes-attach" {
  count       = "${length(aws_instance.kumaradas-73721-poc-public-vms.*.id)}"
  device_name = "${var.block_device_name}"
  volume_id   = "${aws_ebs_volume.kumaradas_73721_ebs_volume.*.id[count.index]}"
  instance_id = "${aws_instance.kumaradas-73721-poc-public-vms.*.id[count.index]}"
}

output public_vm_instance_ip {
  value = "${join(" , ",aws_instance.kumaradas-73721-poc-public-vms.*.public_ip)}"
}

output kumaradas-73721-poc-public-elb {
  value = "${aws_elb.kumaradas-73721-poc-public-elb.dns_name}"
}

output instnaces_AZ {
  value = "${join(" , ",aws_instance.kumaradas-73721-poc-public-vms.*.availability_zone)}"
}
