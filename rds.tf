resource "aws_db_instance" "junction" {
  name = "junction"
  instance_class = "db.m5.large"
  engine = "mysql"
  engine_version = "5.7"
  allocated_storage = 10
  max_allocated_storage = 100

  username = var.db_username
  password = var.db_password
}
