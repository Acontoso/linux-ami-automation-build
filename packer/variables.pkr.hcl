variable "ami_prefix" {
  type        = string
  description = "Name of AMI used to be built"
}

variable "region" {
  type        = string
  description = "Region where the AMI will reside"
  default     = "ap-southeast-2"
}

variable "subnet_id" {
  type        = string
  description = "Subnet where the AMI will be built in"
}

variable "codebuild_cidr_block" {
  type        = list(string)
  description = "CIDR block used by CodeBuild in order to allow connectivity to EC2 instance building AMI"
}

variable "build_tag_number" {
  type        = string
  description = "Codebuild number that is appended to AMI version"
  default     = "1"
}

variable "aws_org_id" {
  type        = list(string)
  description = "AWS organisation ID"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM role to assign to instance while build is being done"
}

variable "environment" {
  type        = string
  description = "Environment the core golden images are being created in"
}

variable "cost_centre" {
  type        = string
  description = "Cost centre to be applied to created resources"
}

variable "source_code_repo_url" {
  type        = string
}
