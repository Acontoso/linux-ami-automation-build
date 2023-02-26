variable "base_image_name" {
  type        = string
  description = "Base name of image used to be built"
}

variable "image_suffix" {
  type        = string
  description = "Suffix of image name"
  default     = "test"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID to build out golden image"
}

variable "client_id" {
  type        = string
  description = "Service Principal running deployment"
}

variable "client_secret" {
  type        = string
  description = "Secret associated with Service Principal"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID to build out image"
}

variable "offer_ubuntu" {
  type        = string
  description = "Base image offer"
}

variable "publisher_ubuntu" {
  type        = string
  description = "Base image publisher"
}

variable "sku_ubuntu" {
  type        = string
  description = "Base image SKU"
}

variable "location" {
  type        = string
  description = "Region to build image in"
}

variable "managed_image_resource_group_name" {
  type        = string
  description = "Where the final image will be saved"
}

variable "virtual_network_name" {
  type        = string
  description = "VNET where the packer image will be built"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource group where the Virtual Network resides"
}

variable "virtual_network_subnet_name" {
  type        = string
  description = "Subnet where to build out VNET"
}

variable "vm_size" {
  type        = string
  description = "Size of VM to build image off"
}

variable "image_gallery_name" {
  type        = string
  description = "Name of image gallery to share golden image"
}

variable "image_gallery_image_name" {
  type        = string
  description = "Name of image gallery image to upload image version to"
}
