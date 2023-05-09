resource "aws_s3_bucket_object" "docker-compose" {
  bucket = aws_s3_bucket.configuration-bucket.id
  key    = "firezone/docker-compose.yml"
  content = file("${path.module}/templates/docker-compose.yml")
  etag = md5(file("${path.module}/templates/docker-compose.yml"))
}