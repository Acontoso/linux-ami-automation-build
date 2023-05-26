resource "aws_iam_policy" "codebuild_iam_policy" {
  name   = "soe_build_policy"
  policy = data.aws_iam_policy_document.codebuild_policy_document_statement.json
  tags   = local.tags
}

resource "aws_iam_role" "codebuild_role" {
  name               = var.iam_role_name_codebuild
  assume_role_policy = data.aws_iam_policy_document.trust_policy_document_codebuild.json
  tags               = local.tags
}

data "aws_iam_policy_document" "trust_policy_document_codebuild" {
  statement {
    sid    = "CodeBuildTrustPolicy"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = [
        "codebuild.amazonaws.com",
      ]

      type = "Service"
    }
  }
}

resource "aws_iam_policy_attachment" "policy_attachment_codebuild_role" {
  name       = "codebuild-role-policy-attachment"
  roles      = [aws_iam_role.codebuild_role.name]
  policy_arn = aws_iam_policy.codebuild_iam_policy.arn
}

data "aws_iam_policy_document" "codebuild_policy_document_statement" {
  #checkov:skip=CKV_AWS_111
  #checkov:skip=CKV_AWS_110
  #checkov:skip=CKV_AWS_109
  #checkov:skip=CKV_AWS_107
  #checkov:skip=CKV_AWS_356
  statement {
    sid    = "AllowEC2"
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeypair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:AssociateInstanceProfileAssociation",
      "ec2:ReplaceIamInstanceProfileAssociaton",
      "ec2:DescribeVpcs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DeleteNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:EnableImageDeprecation",
      "ec2:DisableImageDeprecation"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "AllowCWLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy",
      "logs:ListTagsLogGroup",
      "logs:DeleteLogGroup"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.codebuild_job.name}:*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.codebuild_job.name}"
    ]
  }
  statement {
    sid    = "AllowInstanceProfile"
    effect = "Allow"
    actions = [
      "iam:GetInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
}
