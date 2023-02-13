resource "aws_iam_policy" "packer_iam_policy" {
  name   = "packer_build_policy"
  policy = data.aws_iam_policy_document.packer_policy_document_statement.json
  tags   = local.tags
}

resource "aws_iam_role" "packer_runner_role" {
  name               = "packer_runner_role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_document_packer.json
  tags               = local.tags
}

data "aws_iam_policy_document" "trust_policy_document_packer" {
  statement {
    sid    = "EC2TrustPolicy"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = [
        "ec2.amazonaws.com",
      ]

      type = "Service"
    }
  }
}

resource "aws_iam_policy_attachment" "policy_attachment_packer_role" {
  name       = "packer-role-policy-attachment"
  roles      = [aws_iam_role.packer_runner_role.name]
  policy_arn = aws_iam_policy.packer_iam_policy.arn
}

data "aws_iam_policy_document" "packer_policy_document_statement" {

  statement {
    sid    = "AllowSSMParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/crowdstrike/*",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/qualys/*"
    ]
  }
}

resource "aws_iam_instance_profile" "packer_instance_profile" {
  name = "packer_instance_profile"
  role = aws_iam_role.packer_runner_role.name
}
