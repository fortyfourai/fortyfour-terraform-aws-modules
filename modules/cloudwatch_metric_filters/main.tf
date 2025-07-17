locals {
  # Full map of controls (key → metadata)
  check_map = {
    unauthorized_api_calls = {
      metric_name  = "UnauthorizedAPICalls"
      alarm_name   = "Unauthorized API Calls"
      alarm_desc   = "Detects unauthorized/denied API calls"
      pattern      = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
    }

    console_signin_without_mfa = {
      metric_name = "ConsoleSigninNoMFA"
      alarm_name  = "Console sign‑in without MFA"
      alarm_desc  = "Detects IAM user console logins without MFA"
      pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.userIdentity.type = \"IAMUser\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.responseElements.ConsoleLogin = \"Success\") }"
    }

    root_usage = {
      metric_name = "RootUsage"
      alarm_name  = "Root account usage"
      alarm_desc  = "Detects any use of the root account"
      pattern     = "{ ($.userIdentity.type = \"Root\") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != \"AwsServiceEvent\") }"
    }

    iam_policy_changes = {
      metric_name = "IAMPolicyChanges"
      alarm_name  = "IAM policy changes"
      alarm_desc  = "Detects create/update/delete IAM policy events"
      pattern     = "{ ($.eventSource = \"iam.amazonaws.com\") && ($.eventName = \"CreatePolicy\" || $.eventName = \"DeletePolicy\" || $.eventName = \"CreatePolicyVersion\" || $.eventName = \"DeletePolicyVersion\" || $.eventName = \"Attach*Policy\" || $.eventName = \"Detach*Policy\") }"
    }

    cloudtrail_cfg_changes = {
      metric_name = "CloudTrailCfgChanges"
      alarm_name  = "CloudTrail configuration changes"
      alarm_desc  = "Detects create/update/delete/start/stop CloudTrail"
      pattern     = "{ ($.eventSource = \"cloudtrail.amazonaws.com\") && ($.eventName = \"CreateTrail\" || $.eventName = \"UpdateTrail\" || $.eventName = \"DeleteTrail\" || $.eventName = \"StartLogging\" || $.eventName = \"StopLogging\") }"
    }

    console_auth_failures = {
      metric_name = "ConsoleAuthFailures"
      alarm_name  = "Console authentication failures"
      alarm_desc  = "Detects failed console logins"
      pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.errorMessage = \"Failed authentication\") }"
    }

    disable_or_schedule_cmk_deletion = {
      metric_name = "CMKDisableOrDeletion"
      alarm_name  = "CMK disable or scheduled deletion"
      alarm_desc  = "Detects DisableKey or ScheduleKeyDeletion for customer-managed CMKs"
      pattern     = "{ ($.eventSource = \"kms.amazonaws.com\") && ($.eventName = \"DisableKey\" || $.eventName = \"ScheduleKeyDeletion\") }"
    }

    s3_bucket_policy_changes = {
      metric_name = "S3BucketPolicyChanges"
      alarm_name  = "S3 bucket policy changes"
      alarm_desc  = "Detects changes to S3 bucket policies/ACLs/CORS/Lifecycle"
      pattern     = "{ ($.eventSource = \"s3.amazonaws.com\") && ($.eventName = \"PutBucketAcl\" || $.eventName = \"PutBucketPolicy\" || $.eventName = \"PutBucketCors\" || $.eventName = \"PutBucketLifecycle\" || $.eventName = \"PutBucketReplication\" || $.eventName = \"DeleteBucketPolicy\" || $.eventName = \"DeleteBucketCors\" || $.eventName = \"DeleteBucketLifecycle\" || $.eventName = \"DeleteBucketReplication\") }"
    }

    config_cfg_changes = {
      metric_name = "ConfigCfgChanges"
      alarm_name  = "AWS Config configuration changes"
      alarm_desc  = "Detects stop/delete/modify Config recorder & delivery channel"
      pattern     = "{ ($.eventSource = \"config.amazonaws.com\") && ($.eventName = \"StopConfigurationRecorder\" || $.eventName = \"DeleteDeliveryChannel\" || $.eventName = \"PutDeliveryChannel\" || $.eventName = \"PutConfigurationRecorder\") }"
    }

    security_group_changes = {
      metric_name = "SGChanges"
      alarm_name  = "Security Group changes"
      alarm_desc  = "Detects ingress/egress authz changes to SGs"
      pattern     = "{ ($.eventName = \"AuthorizeSecurityGroupIngress\" || $.eventName = \"AuthorizeSecurityGroupEgress\" || $.eventName = \"RevokeSecurityGroupIngress\" || $.eventName = \"RevokeSecurityGroupEgress\" || $.eventName = \"CreateSecurityGroup\" || $.eventName = \"DeleteSecurityGroup\") }"
    }

    nacl_changes = {
      metric_name = "NACLChanges"
      alarm_name  = "Network ACL changes"
      alarm_desc  = "Detects create/delete/replace NACL rules"
      pattern     = "{ ($.eventName = \"CreateNetworkAcl\" || $.eventName = \"CreateNetworkAclEntry\" || $.eventName = \"DeleteNetworkAcl\" || $.eventName = \"DeleteNetworkAclEntry\" || $.eventName = \"ReplaceNetworkAclEntry\" || $.eventName = \"ReplaceNetworkAclAssociation\") }"
    }

    network_gateway_changes = {
      metric_name = "NetworkGatewayChanges"
      alarm_name  = "Network Gateway changes"
      alarm_desc  = "Detects create/attach/detach/delete Internet & Customer Gateways"
      pattern     = "{ ($.eventName = \"CreateCustomerGateway\" || $.eventName = \"DeleteCustomerGateway\" || $.eventName = \"AttachInternetGateway\" || $.eventName = \"CreateInternetGateway\" || $.eventName = \"DeleteInternetGateway\" || $.eventName = \"DetachInternetGateway\") }"
    }

    route_table_changes = {
      metric_name = "RouteTableChanges"
      alarm_name  = "Route Table changes"
      alarm_desc  = "Detects create/delete/replace routes or associations"
      pattern     = "{ ($.eventName = \"CreateRoute\" || $.eventName = \"DeleteRoute\" || $.eventName = \"ReplaceRoute\" || $.eventName = \"ReplaceRouteTableAssociation\") }"
    }

    vpc_changes = {
      metric_name = "VPCChanges"
      alarm_name  = "VPC changes"
      alarm_desc  = "Detects create/delete/modify VPC & peering configuration"
      pattern     = "{ ($.eventName = \"CreateVpc\" || $.eventName = \"DeleteVpc\" || $.eventName = \"ModifyVpcAttribute\" || $.eventName = \"AcceptVpcPeeringConnection\" || $.eventName = \"CreateVpcPeeringConnection\" || $.eventName = \"DeleteVpcPeeringConnection\" || $.eventName = \"RejectVpcPeeringConnection\" || $.eventName = \"AttachClassicLinkVpc\" || $.eventName = \"DetachClassicLinkVpc\" || $.eventName = \"DisableVpcClassicLink\" || $.eventName = \"EnableVpcClassicLink\") }"
    }
  }

  enabled_map = length(var.enabled_checks) == 0 ? local.check_map : { for k, v in local.check_map : k => v if contains(var.enabled_checks, k) }
}

resource "aws_sns_topic" "alarms" {
  name = "cloudwatch-metric-alarms"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "emails" {
  for_each  = toset(var.subscription_emails)
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_log_metric_filter" "cis" {
  for_each       = local.enabled_map
  name           = each.value.metric_name
  log_group_name = var.log_group_name
  pattern        = each.value.pattern

  metric_transformation {
    name      = each.value.metric_name
    namespace = "CloudWatchMetricFilters"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cis" {
  for_each           = local.enabled_map
  alarm_name         = each.value.alarm_name
  alarm_description  = each.value.alarm_desc
  namespace          = "CloudWatchMetricFilters"
  metric_name        = each.value.metric_name
  statistic          = "Sum"
  period             = 300
  evaluation_periods = 1
  threshold          = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alarms.arn]
}
