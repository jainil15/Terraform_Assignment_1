output "s3" {
  value = aws_s3_bucket.this.bucket
}

output "s3_id" {
  value = aws_s3_bucket.this.id
}