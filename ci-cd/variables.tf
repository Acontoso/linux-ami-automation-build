variable "codebuild_project_name" {
  type        = string
  description = "Name for codebuild project"
}

variable "codebuild_project_description" {
  type        = string
  description = "Description for codebuild project being created"
}

variable "environment" {
  type        = string
  description = "Environment where you're deploying resources for this project"
}

variable "github_repo_url" {
  type        = string
  description = "Name of repository where code resides"
}

variable "branch_to_monitor" {
  type        = string
  description = "Branch Codepipeline will monitor"
}

variable "iam_role_name_codebuild" {
  type        = string
  description = "Name of role for codebuild iam role"
}

variable "iam_role_name_codepipeline" {
  type        = string
  description = "Name of role for codepipeline iam role"
}

variable "version_no" {
  type        = string
  description = "Version of pipeline and builds"
}
