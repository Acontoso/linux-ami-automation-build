variable "codebuild_project_name" {
  type        = string
  description = "Name for codebuild project"
}

variable "codebuild_project_description" {
  type        = string
  description = "Description for codebuild project being created"
}

variable "buildspec_path" {
  type        = string
  description = "Location of buildspec file within source code repository"
}

variable "environment" {
  type        = string
  description = "Environment where you're deploying resources for this project"
}

variable "github_repo_url" {
  type        = string
  description = "Name of repository where code resides"
}

variable "iam_role_name_codebuild" {
  type        = string
  description = "Name of role for codebuild iam role"
}

variable "version_no" {
  type        = string
  description = "Version of pipeline and builds"
}

variable "github_repo_url_https" {
  type        = string
  description = "Name of repository where code resides, but HTTPS endpoint for API calls"
}