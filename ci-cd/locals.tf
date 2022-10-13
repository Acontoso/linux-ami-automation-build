locals {
  tags = merge(
    {
      "GithubURL"   = "${var.github_repo_url}"
      "Environment" = "${var.environment}"
      "Terraform"   = "True"
      "Version"     = "${var.version_no}"
    }
  )
}
