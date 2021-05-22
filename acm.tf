resource "aws_acm_certificate" "sangminout_certi" {
  provider = "aws.virginia"
  domain_name = "*.sangmin.in"
  validation_method = "EMAIL"

  subject_alternative_names = ["sangmin.in"]
}

resource "aws_acm_certificate" "junction_sangmin_certi" {
  provider = "aws.virginia"
  domain_name = "*.junction.sangmin.in"
  validation_method = "DNS"

  subject_alternative_names = ["junction.sangmin.in"]
}
