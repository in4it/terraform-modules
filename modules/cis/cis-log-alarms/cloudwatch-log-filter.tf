locals {
  aws_cis_rules = {
    "CIS4.1-UnauthorizedApiCalls" = {
      pattern     = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
      description = "4.1 – Ensure a log metric filter and alarm exist for unauthorized API calls"
    }
    "CIS4.2-ConsoleLoginWithoutMFA" = {
      pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.userIdentity.type = \"IAMUser\") && ($.responseElements.ConsoleLogin = \"Success\") }"
      description = "4.2 – Ensure a log metric filter and alarm exist for AWS Management Console sign-in without MFA"
    }
    "CIS4.3-RootAccountUsage" = {
      pattern     = "{$.userIdentity.type=\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\"}"
      description = "4.3 – Eliminate use of the root user for administrative and daily tasks"
    }
    "CIS4.4-IamPolicyChange" = {
      pattern     = "{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}"
      description = "4.4 – Ensure a log metric filter and alarm exist for IAM policy changes"
    }
    "CIS4.5-CloudtrailChanges" = {
      pattern     = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
      description = "4.5 – Ensure a log metric filter and alarm exist for CloudTrail configuration changes"
    }
    "CIS4.6-ConsoleFailedAuth" = {
      pattern     = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"
      description = "4.6 – Ensure a log metric filter and alarm exist for AWS Management Console authentication failures"
    }
    "CIS4.7-CmkDelete" = {
      pattern     = "{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}"
      description = "4.7 – Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer managed keys"
    }
    "CIS4.8-S3BucketPolicyChanges" = {
      pattern     = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
      description = "4.8 – Ensure a log metric filter and alarm exist for S3 bucket policy changes"
    }
    "CIS4.9-AwsConfigChanges" = {
      pattern     = "{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}"
      description = "4.9 – Ensure a log metric filter and alarm exist for AWS Config configuration changes"
    }
    "CIS4.10-SecurityGroupsChanges" = {
      pattern     = "{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}"
      description = "4.10 – Ensure a log metric filter and alarm exist for security group changes"
    }
    "CIS4.11-NaclChanges" = {
      pattern     = "{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}"
      description = "4.11 – Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL)"
    }
    "CIS4.12-NetworkGatewaysChanges" = {
      pattern     = "{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}"
      description = "4.12 – Ensure a log metric filter and alarm exist for changes to network gateways"
    }
    "CIS4.13-RouteTableChanges" = {
      pattern     = "{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}"
      description = "4.13 – Ensure a log metric filter and alarm exist for route table changes"
    }
    "CIS4.14-VpcChanges" = {
      pattern     = "{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}"
      description = "4.14 – Ensure a log metric filter and alarm exist for VPC changes"
    }
    "CIS4.15-OrgChanges" = {
      pattern     = "{ ($.eventSource = organizations.amazonaws.com) && (($.eventName = \"AcceptHandshake\") || ($.eventName = \"AttachPolicy\") || ($.eventName = \"CreateAccount\") || ($.eventName = \"CreateOrganizationalUnit\") || ($.eventName = \"CreatePolicy\") || ($.eventName = \"DeclineHandshake\") || ($.eventName = \"DeleteOrganization\") || ($.eventName = \"DeleteOrganizationalUnit\") || ($.eventName = \"DeletePolicy\") || ($.eventName = \"DetachPolicy\") || ($.eventName = \"DisablePolicyType\") || ($.eventName = \"EnablePolicyType\") || ($.eventName = \"InviteAccountToOrganization\") || ($.eventName = \"LeaveOrganization\") || ($.eventName = \"MoveAccount\") || ($.eventName = \"RemoveAccountFromOrganization\") || ($.eventName = \"UpdatePolicy\") || ($.eventName = \"UpdateOrganizationalUnit\")) }"
      description = "4.15 Ensure a log metric filter and alarm exists for AWS Organizations changes"
    }
  }
}


resource "aws_cloudwatch_log_metric_filter" "aws_cis_rules" {
  for_each = local.aws_cis_rules

  name           = each.key
  pattern        = each.value.pattern
  log_group_name = var.existing_log_group_name

  metric_transformation {
    name      = each.key
    namespace = var.alarm_namespace
    value     = "1"
  }
}


resource "aws_cloudwatch_metric_alarm" "aws_cis_rules" {
  for_each = local.aws_cis_rules

  alarm_description         = each.value.description
  alarm_name                = each.key
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = []
  metric_name               = aws_cloudwatch_log_metric_filter.aws_cis_rules[each.key].id
  namespace                 = var.alarm_namespace
  ok_actions                = [var.sns_arn]
  period                    = 300
  statistic                 = "Sum"
  alarm_actions             = [var.sns_arn]
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  tags                      = var.tags
}