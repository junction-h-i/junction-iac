resource "aws_db_instance" "junction" {
  name = "junction"
  instance_class = "db.m5.large"
  engine = "mysql"
  engine_version = "5.7"
  allocated_storage = 10
  max_allocated_storage = 100
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.public_db.id]

  username = var.db_username
  password = var.db_password
}
