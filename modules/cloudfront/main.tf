data "aws_acm_certificate" "issued" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "frontend_distribution" {
  enabled = true

  origin {
    domain_name = var.alb_domain_name
    origin_id   = var.alb_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.alb_domain_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = []
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["US", "CA"]
    }
  }

  tags = {
    Name = var.project_name
  }
  
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.issued.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
