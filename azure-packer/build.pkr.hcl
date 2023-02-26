source "azure-arm" "ubuntu_vm" {
  async_resourcegroup_delete              = true
  subscription_id                         = var.subscription_id
  client_id                               = var.client_id
  client_secret                           = var.client_secret
  communicator                            = "ssh"
  image_offer                             = var.offer_ubuntu
  image_publisher                         = var.publisher_ubuntu
  image_sku                               = var.sku_ubuntu
  location                                = var.location
  managed_image_name                      = "${var.base_image_name}-ubuntu-${var.image_suffix}"
  managed_image_resource_group_name       = var.managed_image_resource_group_name
  os_type                                 = "Linux"
  private_virtual_network_with_public_ip  = true
  virtual_network_name                    = var.virtual_network_name
  virtual_network_resource_group_name     = var.virtual_network_resource_group_name
  virtual_network_subnet_name             = var.virtual_network_subnet_name
  tenant_id                               = var.tenant_id
  vm_size                                 = var.vm_size
  ssh_username                            = "ubuntu"

  shared_image_gallery_destination {
    subscription = var.subscription_id
    resource_group = var.managed_image_resource_group_name
    gallery_name = var.image_gallery_name
    image_name = var.image_gallery_image_name
    image_version = "1.0.0"
    replication_regions = ["Australia East"]
    storage_account_type = "Standard_LRS"
  }
}

build {
  sources = [
    "sources.azure-arm.ubuntu_vm"
  ]

  provisioner "file" {
    destination = "/tmp/"
    source      = "soe-build-linux-artifact/scripts/"
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/mv_script.sh"]
  }

  provisioner "shell" {
    inline = ["sudo bash /tmp/set_up_packages.sh"]
  }

  provisioner "ansible-local" {
    playbook_file = "soe-build-linux-artifact/ansible/soe.yml"
    role_paths = [
      "soe-build-linux-artifact/ansible/roles/harden"
    ]
  }

provisioner "shell" {
   execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
   inline = [
        "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
   ]
   inline_shebang = "/bin/sh -x"
  }
}
