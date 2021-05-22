provider "aws" {
  region = "ap-northeast-2"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

variable "junction_host" {
  default = "junction.sangmin.in"
}

resource "aws_s3_bucket" "static" {
  bucket = var.junction_host
  acl = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::junction.sangmin.in/*"]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_acm_certificate" "sangminout_certi" {
  provider = "aws.virginia"
  domain_name = "*.sangmin.in"
  validation_method = "EMAIL"

  subject_alternative_names = ["sangmin.in"]
}

resource "aws_cloudfront_distribution" "junction_distribution" {
  enabled = true
  default_root_object = "index.html"

  aliases = [var.junction_host]

  origin {
    domain_name = "${aws_s3_bucket.static.website_endpoint}"
    origin_id = var.junction_host
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["HEAD", "GET"]
    cached_methods = ["HEAD", "GET"]
    target_origin_id = var.junction_host
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.sangminout_certi.arn}"
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_zone" "junction_zone" {
  name = var.junction_host
}

resource "aws_route53_record" "junction" {
  name = var.junction_host
  type = "A"
  zone_id = "${aws_route53_zone.junction_zone.zone_id}"

  alias {
    name = "${aws_cloudfront_distribution.junction_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.junction_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
