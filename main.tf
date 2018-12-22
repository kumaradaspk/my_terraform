resource "aws_instance" "kumaradas-73721-poc" {
  ami                    = "ami-08419d23bf91152e4"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  subnet_id              = "${aws_subnet.kumaradas-73721-public.id}"
  vpc_security_group_ids = ["${aws_security_group.kumaradas-73721-poc-allow-frm-all-IP.id}"]

  tags {
    Name = "kumaradas-73721-poc"
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

output ip {
  value = "${aws_instance.kumaradas-73721-poc.public_ip}"
}
