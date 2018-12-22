data "aws_availability_zones" "available" {}

resource "aws_vpc" "kumaradas-73721-global-vpc" {
  cidr_block = "10.0.0.0/16"

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

resource "aws_subnet" "kumaradas-73721-private" {
  vpc_id                  = "${aws_vpc.kumaradas-73721-global-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "kumaradas-main-private-subnet"
  }
}

resource "aws_subnet" "kumaradas-73721-public" {
  vpc_id                  = "${aws_vpc.kumaradas-73721-global-vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "kumaradas-main-public-subnet"
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

resource "aws_route_table_association" "kumaradas-73721-public" {
  subnet_id      = "${aws_subnet.kumaradas-73721-public.id}"
  route_table_id = "${aws_route_table.kumaradas-73721-poc-vpc-route_table.id}"
}
