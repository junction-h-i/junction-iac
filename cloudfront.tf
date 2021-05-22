resource "aws_cloudfront_distribution" "junction_distribution" {
  enabled = true
  default_root_object = "index.html"

  aliases = [var.junction_host]

  origin {
    domain_name = aws_s3_bucket.static.website_endpoint
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
    acm_certificate_arn = aws_acm_certificate.sangminout_certi.arn
    ssl_support_method = "sni-only"
  }
}
