resource "aws_s3_bucket" "s3_bucket" {
  bucket   = "fgtvmconnectcloudinit${random_string.bucket_suffix.result}"
}