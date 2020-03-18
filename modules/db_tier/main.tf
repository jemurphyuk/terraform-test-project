
resource "aws_subnet" "db_subnet" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.1.20.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "${var.sparta_name}-subnet-mongodb"
  }
}

resource "aws_security_group" "db_sg"  {
  name = "${var.name}"
  description = "database security group"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "27017"
    to_port         = "27017"
    protocol        = "tcp"
    security_groups = ["sg-07038786cd193775f"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sparta_name}-db-sg1"
  }
}


resource "aws_network_acl" "db" {
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
    cidr_block = "10.1.10.0/24"
    from_port  = 27017
    to_port    = 27017
  }

  # EPHEMERAL PORTS
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "10.1.10.0/24"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "10.1.20.0/24"
    from_port  = 1024
    to_port    = 65535
  }
  subnet_ids   = ["${aws_subnet.db_subnet.id}"]
  tags = {
    Name = "${var.sparta_name}-nacl-app"
  }
}

resource "aws_instance" "db_instance" {
  ami = "${var.ami-db}"
  subnet_id = "${aws_subnet.db_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  instance_type = "t2.micro"
  associate_public_ip_address = false
  tags = {
    Name = "${var.name}"
  }
}
