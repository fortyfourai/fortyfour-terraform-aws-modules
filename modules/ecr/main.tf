data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "default_ecr_policy" {
  statement {
    sid    = "DefaultAccountAccessOnly"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
  }
}

locals {
  # Use the custom policy if provided, otherwise use the generated default policy.
  effective_policy_json = var.custom_policy_json != null ? var.custom_policy_json : data.aws_iam_policy_document.default_ecr_policy.json
}

resource "aws_ecr_repository" "repo" {
  for_each = toset(var.repository_names)

  name = each.key

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.enable_scan_on_push
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_type != null ? [1] : []
    content {
      encryption_type = var.encryption_type
      kms_key         = var.encryption_type == "KMS" ? var.kms_key_arn : null
    }
  }

  force_delete = var.force_delete
  tags         = merge(var.tags, { "TerraformManaged" = "true" }) # Add a default tag
}

resource "aws_ecr_repository_policy" "repo_policy" {
  for_each = aws_ecr_repository.repo

  repository = each.value.name
  policy     = local.effective_policy_json

  depends_on = [aws_ecr_repository.repo]
}