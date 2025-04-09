resource "aws_route53_record" "web_server" {
  zone_id = var.domain_zone_id
  name    = "react.${var.domain_name}"
  type    = "A" # alias: aws_route53 -> aws_cloudfront

  alias {
    name                   = aws_cloudfront_distribution.web_server.domain_name
    zone_id                = aws_cloudfront_distribution.web_server.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "gitlab" {
  zone_id = var.domain_zone_id
  name    = "gitlab.${var.domain_name}"
  type    = "A" # alias: aws_route53 -> gitlab

  alias {
    name                   = var.web_alb.dns_name
    zone_id                = var.web_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id = var.domain_zone_id
  name    = "jenkins.${var.domain_name}"
  type    = "A" # alias: aws_route53 -> jenkins

  alias {
    name                   = var.web_alb.dns_name
    zone_id                = var.web_alb.zone_id
    evaluate_target_health = false
  }
}
