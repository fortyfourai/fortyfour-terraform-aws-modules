resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { "TerraformManaged" = "true" })

}

# Compliance: Enables object versioning.
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.this.id

  target_bucket = var.log_bucket_name
  target_prefix = var.log_prefix
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.ownership_controls_rule
  }
}

resource "aws_s3_bucket_policy" "custom_policy" {
  count = var.custom_policy_json != null ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = var.custom_policy_json

  # Ensure public access block settings are applied first.
  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_master_key_id : null
    }
  }
}
