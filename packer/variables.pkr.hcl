variable "ami_name" {
  type        = string
  description = "Name of AMI used to be built"
  default     = "contoso-ubuntu-ami"
}

variable "region" {
  type        = string
  description = "Region where the AMI will reside"
  default     = "ap-southeast-2"
}

variable "subnet_id" {
  type        = string
  description = "Subnet where the AMI will be built in"
  default     = "subnet-7694e62e"
}

variable "codebuild_cidr_block" {
  type        = list(string)
  description = "CIDR block used by CodeBuild in order to allow connectivity to EC2 instance building AMI"
  default     = ["13.55.255.216/29", "3.26.127.24/29"]
}

variable "build_tag_number" {
  type        = string
  description = "Codebuild number that is appended to AMI version"
  default     = "1"
}
