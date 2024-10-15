# Frontend S3 Bucket
resource "aws_s3_bucket" "munggae_website" {
  bucket = "munggae-bucket"
  acl    = "private"  # ACL을 private으로 설정합니다.

  # 정적 웹 호스팅 설정
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = "munggae Website"
  }
}

# S3 버킷의 공용 접근 차단 설정
resource "aws_s3_bucket_public_access_block" "munggae_website_public_access_block" {
  bucket = aws_s3_bucket.munggae_website.id

  block_public_acls       = false  # 공용 ACL을 차단하지 않도록 설정
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# CloudFront OAC
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "munggae-oac"
  description                       = "OAC for munggae S3 bucket"
  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "munggae_website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.munggae_website.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.munggae_website.id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.munggae_website.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "munggae Website Distribution"
  }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "munggae_website_policy" {
  bucket = aws_s3_bucket.munggae_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.munggae_website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.munggae_website_distribution.arn
          }
        }
      }
    ]
  })
}
