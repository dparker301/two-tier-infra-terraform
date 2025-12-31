resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.env}-dbsubnets"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "db" {
  name   = "${var.project_name}-${var.env}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "MySQL from Jenkins SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.allowed_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.env}-rds-sg" }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-${var.env}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0
}
