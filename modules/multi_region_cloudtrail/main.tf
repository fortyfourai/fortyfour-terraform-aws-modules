resource "aws_cloudwatch_log_group" "trail" {
  name              = "/aws/cloudtrail/${var.trail_name}"
  retention_in_days = var.cloudwatch_log_retention_days
  kms_key_id        = var.logs_bucket_kms_key_arn != "" ? var.logs_bucket_kms_key_arn : null
}


data "aws_iam_policy_document" "trail_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "trail_to_cw" {
  name               = "${var.trail_name}-to-cw"
  assume_role_policy = data.aws_iam_policy_document.trail_assume.json
}

data "aws_iam_policy_document" "cw_write" {
  statement {
    sid       = "CWLogWrite"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.trail.arn}:*"]
  }
}

resource "aws_iam_role_policy" "trail_to_cw" {
  role   = aws_iam_role.trail_to_cw.id
  policy = data.aws_iam_policy_document.cw_write.json
}


data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [var.logs_bucket_arn]
  }

  statement {
    sid = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = ["${var.logs_bucket_arn}/AWSLogs/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "trail" {
  bucket = var.logs_bucket_name
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_cloudtrail" "this" {
  name                          = var.trail_name
  s3_bucket_name                = var.logs_bucket_name
  kms_key_id                    = var.logs_bucket_kms_key_arn
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.trail.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.trail_to_cw.arn
  depends_on = [aws_cloudwatch_log_group.trail, aws_iam_role.trail_to_cw]
}