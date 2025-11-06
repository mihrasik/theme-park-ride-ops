resource "aws_db_instance" "theme_park_db" {
  allocated_storage    = 20
  storage_type       = "gp2"
  engine             = "mariadb"
  engine_version     = "10.5"
  instance_class     = "db.t3.micro"
  name               = var.db_name
  username           = var.db_username
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.theme_park_subnet.id
  vpc_security_group_ids = [aws_security_group.theme_park_sg.id]
  multi_az           = false
  backup_retention_period = 7
  skip_final_snapshot = true

  tags = {
    Name = "ThemeParkDB"
  }
}

resource "aws_db_subnet_group" "theme_park_subnet" {
  name       = "theme-park-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "ThemeParkSubnetGroup"
  }
}

resource "aws_security_group" "theme_park_sg" {
  name        = "theme-park-sg"
  description = "Allow access to the Theme Park database"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ThemeParkSG"
  }
}