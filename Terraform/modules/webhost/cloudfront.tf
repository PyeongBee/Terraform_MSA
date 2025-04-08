resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.prefix}-webserver-oac-${var.postfix}"
  description                       = "OAC for S3 static site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "web_server" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = var.s3_domain_name
    origin_id   = "hansS2SWebServerOriginTf"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "hansS2SWebServerOriginTf"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:${var.admin_aws_id}:certificate/${var.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = ["react.${var.domain_name}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"
}
