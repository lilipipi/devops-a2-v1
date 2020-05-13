resource "aws_db_subnet_group" "devops_assignment2_db" {
  name       = "main"
  subnet_ids = [aws_subnet.data_az1.id, aws_subnet.data_az2.id, aws_subnet.data_az3.id]

  tags = {
    Name = "db subnets"
  }
}

resource "aws_security_group" "allow_db_ip" {
  name        = "allow_db_ip"
  description = "Allow all ips to connect to database"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "more db ip connection"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_db_ip"
  }
}


resource "aws_db_instance" "devops_assignment2_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6.16"
  instance_class       = "db.t2.micro"
  name                 = "devops_assignment2_db"
  username             = "postgres"
  password             = "rmittute"
  db_subnet_group_name = "main"
  identifier           = "devops-assignment2-db"
  # final_snapshot_identifier = "devops-assignment2-db"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.allow_db_ip.id]
}

data "aws_instance" "devops_assignment2" {
  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}