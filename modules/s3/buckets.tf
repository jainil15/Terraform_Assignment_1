# Creating S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = var.s3_name

  tags = {
    Name = "${var.s3_name}"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
