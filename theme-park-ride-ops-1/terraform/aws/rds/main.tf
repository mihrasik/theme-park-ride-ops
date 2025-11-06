resource "aws_db_instance" "theme_park_db" {
  allocated_storage    = var.allocated_storage
  storage_type       = var.storage_type
  engine            = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  db_name            = var.db_name
  username           = var.username
  password           = var.password
  db_subnet_group_name = aws_db_subnet_group.theme_park_subnet_group.name
  vpc_security_group_ids = [aws_security_group.theme_park_sg.id]
  multi_az           = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot = true

  tags = {
    Name = "theme-park-db"
  }
}

resource "aws_db_subnet_group" "theme_park_subnet_group" {
  name       = "theme-park-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "theme-park-subnet-group"
  }
}

resource "aws_security_group" "theme_park_sg" {
  name        = "theme-park-sg"
  description = "Allow access to the theme park database"

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
    Name = "theme-park-sg"
  }
}