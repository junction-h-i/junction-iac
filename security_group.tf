resource "aws_security_group" "public_db" {
  name = "public_db"

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public_db"
  }
}
