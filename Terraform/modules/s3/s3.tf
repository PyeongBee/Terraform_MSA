resource "aws_s3_bucket" "web_server" {
  bucket        = "${var.prefix}-s3-webserver-${var.postfix}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "web_server" {
  bucket = aws_s3_bucket.web_server.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.web_server.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.web_server.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "web_server" {
  bucket = aws_s3_bucket.web_server.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
