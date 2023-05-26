locals {
  #3 months deprecation time. Job should be built every month
  deprecate_time = formatdate("YYYY-MM-DD'T'HH:MM:ssZ", timeadd(timestamp(), "2190h"))
}

source "amazon-ebs" "ubuntu_20_04" {
  ami_name               = "${var.ami_name}-${var.build_tag_number}"
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
  subnet_id                             = var.subnet_id
  temporary_security_group_source_cidrs = var.codebuild_cidr_block
  deprecate_at                          = local.deprecate_time
  iam_instance_profile                  = "packer_instance_profile"
  encrypt_boot                          = true
}

build {
  sources = [
    "sources.amazon-ebs.ubuntu_20_04"
  ]

  provisioner "file" {
    destination = "/tmp/"
    source      = "scripts/"
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/mv_script.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/set_up_packages.sh"]
  }

  provisioner "ansible-local" {
    playbook_file = "ansible/soe.yml"
    role_paths = [
      "ansible/roles/harden"
    ]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/crowdstrike_install/install_crowdstrike.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/qualys_install/install_qualys.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/install_docker.sh"]
  }
}
