locals {
  #3 months deprecation time. Job should be built every month
  deprecate_time = formatdate("YYYY-MM-DD hh:mm:ss", timeadd(timestamp(), "2190h"))
}

source "amazon-ebs" "ubuntu_20_04" {
  ami_name = "${var.ami_name}-${var.build_tag_number}"
  region   = var.region
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
  deprecate_at = local.deprecate_time
}

build {
  sources = [
    "sources.amazon-ebs.ubuntu_20_04"
  ]

  provisioner "file" {
    destination = "/tmp/"
    source      = "../scripts/mv_script.sh"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "../scripts/defender_service_script.sh"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "../scripts/defender_install.service"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "../scripts/install_defender.sh"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "../scripts/set_up_packages.sh"
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/mv_script.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/set_up_packages.sh"]
  }

  provisioner "ansible" {
    playbook_file = "../ansible/soe.yml"
  }
}
