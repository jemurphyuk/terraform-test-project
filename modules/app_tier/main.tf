
data "aws_internet_gateway" "default" {
  filter {
    name = "attachment.vpc-id"
    values = ["${var.vpc_id}"]
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.default.id}"
  }
  tags = {
    Name = "${var.sparta_name}-public-rt"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.1.10.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "${var.sparta_name}-subnet-nodejs"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = "${aws_subnet.app_subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_security_group" "app_sg"  {
  name = "${var.name}"
  description = "nodejs security group"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = "1024"
    to_port         = "65535"
    protocol        = "tcp"
    cidr_blocks     = ["10.1.20.0/24"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sparta_name}-nodejs-sg1"
  }
}


resource "aws_network_acl" "app" {
  vpc_id = "${var.vpc_id}"
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # EPHEMERAL PORTS
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  subnet_ids   = ["${aws_subnet.app_subnet.id}"]
  tags = {
    Name = "${var.sparta_name}-nacl-app"
  }
}

resource "aws_instance" "app_instance" {
  ami = "${var.ami_app}"
  subnet_id = "${aws_subnet.app_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  user_data = "${var.user_data}"
  tags = {
    Name = "${var.name}"
  }
}
