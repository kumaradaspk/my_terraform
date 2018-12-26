data "aws_availability_zones" "available" {}

resource "aws_vpc" "kumaradas-73721-global-vpc" {
  #cidr_block = "10.0.0.0/16"
  cidr_block = "${var.network_address_space}"

  tags {
    Name = "kumaradas-73721-main-vpc"
  }
}

resource "aws_internet_gateway" "kumaradas-73721-poc-gw" {
  vpc_id = "${aws_vpc.kumaradas-73721-global-vpc.id}"

  tags {
    Name = "kumaradas-73721-poc-gw"
  }
}

resource "aws_subnet" "kumaradas_73721_public_subnet" {
  count                   = "${var.public_subnet_count}"
  cidr_block              = "${cidrsubnet(var.network_address_space,8,count.index + 1)}"
  vpc_id                  = "${aws_vpc.kumaradas-73721-global-vpc.id}"
  map_public_ip_on_launch = true

  #availability_zone       = "${data.aws_availability_zones.available.names[count.index + 1]}"
  availability_zone = "${element(split(",",var.aws_availability_zones[var.aws_region]), count.index % var.public_subnet_count)}"

  tags {
    Name = "kumaradas_73721_public_subnet-${count.index}"
  }
}

resource "aws_subnet" "kumaradas_73721_private_subnet" {
  count                   = "${var.private_subnet_count}"
  cidr_block              = "${cidrsubnet(var.network_address_space,8,count.index + var.public_subnet_count + 1)}"
  vpc_id                  = "${aws_vpc.kumaradas-73721-global-vpc.id}"
  map_public_ip_on_launch = true

  #availability_zone       = "${data.aws_availability_zones.available.names[count.index + 1]}"
  availability_zone = "${element(split(",",var.aws_availability_zones[var.aws_region]), count.index % var.private_subnet_count)}"

  tags {
    Name = "kumaradas_73721_private_subnet-${count.index}"
  }
}

resource "aws_route_table" "kumaradas-73721-poc-vpc-route_table" {
  vpc_id = "${aws_vpc.kumaradas-73721-global-vpc.id}"

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kumaradas-73721-poc-gw.id}"
  }

  tags {
    Name = "kumaradas-73721-poc-vpc-route_table"
  }
}

resource "aws_route_table_association" "rta-kumaradas-73721-public-subnet" {
  count          = "${var.public_subnet_count}"
  subnet_id      = "${element(aws_subnet.kumaradas_73721_public_subnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.kumaradas-73721-poc-vpc-route_table.id}"
}

resource "aws_route_table_association" "rta-kumaradas-73721-private-subnet" {
  count          = "${var.private_subnet_count}"
  subnet_id      = "${element(aws_subnet.kumaradas_73721_private_subnet.*.id,count.index + var.public_subnet_count + 1)}"
  route_table_id = "${aws_route_table.kumaradas-73721-poc-vpc-route_table.id}"
}
