variable "version_no" {
  type        = string
  description = "Version of pipeline and builds"
}

variable "github_repo_url" {
  type        = string
  description = "Name of repository where code resides"
}

variable "environment" {
  type        = string
  description = "Environment where you're deploying resources for this project"
}
