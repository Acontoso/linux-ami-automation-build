locals {
  #3 months deprecation time. Job should be built every month
  deprecate_time = formatdate("YYYY-MM-DD'T'HH:MM:ssZ", timeadd(timestamp(), "2190h"))
  tags = merge(
    {
      "env"        = "${var.environment}",
      "terraform"  = "true"
      "bu"         = "security"
      "repourl"    = "${var.source_code_repo_url}"
      "service"    = "soe-build"
      "author"     = "askoro"
      "costcentre" = "${var.cost_centre}"
    }
  )
}

source "amazon-ebs" "ubuntu_20_04" {
  ami_name               = "${var.ami_prefix}-${var.build_tag_number}-ubuntu20.04"
  ami_org_arns           = var.aws_org_id
  region                 = var.region
  skip_region_validation = true
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username                          = "ubuntu"
  instance_type                         = "t3.xlarge"
  subnet_id                             = var.subnet_id #assumes subnet is public with publicIP automatically configured on launched instances in subnet - create dedicated build subnet
  temporary_security_group_source_cidrs = var.codebuild_cidr_block
  deprecate_at                          = local.deprecate_time
  iam_instance_profile                  = var.iam_instance_profile
  run_volume_tags                       = local.tags
  tags                                  = local.tags
  imds_support                          = "v2.0"
}

source "amazon-ebs" "ubuntu_22_04" {
  ami_name               = "${var.ami_prefix}-${var.build_tag_number}-ubuntu22.04"
  ami_org_arns           = var.aws_org_id
  region                 = var.region
  skip_region_validation = true
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username                          = "ubuntu"
  instance_type                         = "t3.xlarge"
  subnet_id                             = var.subnet_id #assumes subnet is public with publicIP automatically configured on launched instances in subnet - create dedicated build subnet
  temporary_security_group_source_cidrs = var.codebuild_cidr_block
  deprecate_at                          = local.deprecate_time
  iam_instance_profile                  = var.iam_instance_profile
  run_volume_tags                       = local.tags
  tags                                  = local.tags
  imds_support                          = "v2.0"
}

// source "amazon-ebs" "open_suse_15" {
//   ami_name               = "${var.ami_prefix}-${var.build_tag_number}"
//   ami_org_arns           = var.aws_org_id
//   region                 = var.region
//   skip_region_validation = true
//   source_ami_filter {
//     filters = {
//       virtualization-type = "hvm"
//       root-device-type    = "ebs"
//       name                = "suse-sles-15-sp5-*"
//     }
//     most_recent = true
//     owners      = ["amazon"]
//   }
//   ssh_username                          = "ubuntu"
//   instance_type                         = "t3.xlarge"
//   subnet_id                             = var.subnet_id #assumes subnet is public with publicIP automatically configured on launched instances in subnet - create dedicated build subnet
//   temporary_security_group_source_cidrs = var.codebuild_cidr_block
//   deprecate_at                          = local.deprecate_time
//   iam_instance_profile                  = var.iam_instance_profile
//   encrypt_boot                          = true
//   run_volume_tags                       = local.tags
//   tags                                  = local.tags
//   imds_support                          = "v2.0"
// }

build {
  sources = [
    "sources.amazon-ebs.ubuntu_20_04",
    "sources.amazon-ebs.ubuntu_22_04"
  ]

  provisioner "file" {
    destination = "/tmp/"
    source      = "scripts/linux/"
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/mv_script.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/set_up_packages.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/install_arc.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/install_docker.sh"]
  }

  provisioner "ansible-local" {
    playbook_file = "ansible/soe.yml"
    role_paths = [
      "ansible/roles/harden"
    ]
  }
}

source "amazon-ebs" "win_2022" {
  ami_name               = "${var.ami_prefix}-${var.build_tag_number}-win2022"
  ami_org_arns           = var.aws_org_id
  region                 = var.region
  skip_region_validation = true
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      name                = "Windows_Server-2022-English-Core-Base-*"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  communicator                          = "winrm"
  winrm_insecure                        = true
  winrm_username                        = "Administrator"
  winrm_use_ssl                         = true
  instance_type                         = "t3.xlarge"
  subnet_id                             = var.subnet_id #assumes subnet is public with publicIP automatically configured on launched instances in subnet - create dedicated build subnet
  temporary_security_group_source_cidrs = var.codebuild_cidr_block
  deprecate_at                          = local.deprecate_time
  iam_instance_profile                  = var.iam_instance_profile
  run_volume_tags                       = local.tags
  tags                                  = local.tags
  imds_support                          = "v2.0"
}

build {
  sources = [
    "sources.amazon-ebs.win_2022"
  ]
  #defining this script to be ran first
  provisioner "powershell" {
    scripts = [
      "scripts/windows-server/generic_tool_install.ps1",
    ]
  }

  provisioner "powershell" {
    inline = [
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/InitializeInstance.ps1 -Schedule",
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SysprepInstance.ps1 -NoShutdown"
    ]
  }
}
