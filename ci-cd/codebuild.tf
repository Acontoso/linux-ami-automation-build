data "aws_kms_secrets" "credentials" {
  secret {
    name    = "secrets"
    payload = file("${path.module}/${var.environment}-creds.yml.encrypted")
  }
}

locals {
  secrets = yamldecode(data.aws_kms_secrets.credentials.plaintext["secrets"])
}

resource "aws_codebuild_project" "codebuild_job" {
  #checkov:skip=CKV_AWS_147: Ensure that CodeBuild projects are encrypted - No artifacts so not required
  #checkov:skip=CKV_AWS_314: "Ensure CodeBuild project environments have a logging configuration"
  name          = var.codebuild_project_name
  description   = var.codebuild_project_description
  build_timeout = "300"
  service_role  = aws_iam_role.codebuild_role.arn
  tags          = local.tags

  environment {
    compute_type    = "BUILD_GENERAL1_MEDIUM"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

  }
  source {
    report_build_status = true
    location            = var.github_repo_url_https
    type                = "GITHUB"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}

resource "aws_codebuild_source_credential" "codebuild_credentials_github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = local.secrets.api_key
}

resource "aws_codebuild_webhook" "codebuild_trigger" {
  project_name = aws_codebuild_project.codebuild_job.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}
