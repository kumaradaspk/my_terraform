resource "aws_security_group" "kumaradas-73721-poc-allow-frm-all-IP" {
  vpc_id = "${aws_vpc.kumaradas-73721-global-vpc.id}"
  name   = "kumaradas-73721-poc-allow-frm-all-IP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    #cidr_blocks = ["${var.network_address_space}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "kumaradas-73721-poc-allow-frm-all-IP"
  }
}

resource "aws_security_group" "kumaradas-73721-poc-allow-frm-all-IP-80" {
  vpc_id = "${aws_vpc.kumaradas-73721-global-vpc.id}"
  name   = "kumaradas-73721-poc-allow-frm-all-IP-80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "kumaradas-73721-poc-allow-frm-all-IP-80"
  }
}
