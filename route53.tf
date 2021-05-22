resource "aws_route53_zone" "junction_zone" {
  name = var.junction_host
}

resource "aws_route53_record" "junction" {
  name = var.junction_host
  type = "A"
  zone_id = aws_route53_zone.junction_zone.zone_id

  alias {
    name = aws_cloudfront_distribution.junction_distribution.domain_name
    zone_id = aws_cloudfront_distribution.junction_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "junction_api" {
  name = "api.junction.sangmin.in"
  type = "A"
  zone_id = aws_route53_zone.junction_zone.zone_id

  alias {
    name = aws_cloudfront_distribution.junction_api_distribution.domain_name
    zone_id = aws_cloudfront_distribution.junction_api_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
