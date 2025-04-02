resource "aws_route53_record" "site" {
  zone_id = "Z06532643EU99ZO2Z2G2E"
  name    = "react.hans.tf-dunn.link"
  type    = "A" # alias: aws_route53 -> aws_cloudfront

  alias {
    name                   = aws_cloudfront_distribution.web_server.domain_name
    zone_id                = aws_cloudfront_distribution.web_server.hosted_zone_id
    evaluate_target_health = false
  }
}
