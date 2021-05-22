resource "aws_acm_certificate" "sangminout_certi" {
  provider = "aws.virginia"
  domain_name = "*.sangmin.in"
  validation_method = "EMAIL"

  subject_alternative_names = ["sangmin.in"]
}
