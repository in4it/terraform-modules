resource "aws_s3_object" "docker-compose" {
  bucket = aws_s3_bucket.configuration-bucket.id
  key    = "firezone/docker-compose.yml"
  source = "${path.module}/templates/docker-compose.yml"
  etag   = filemd5("${path.module}/templates/docker-compose.yml")
}