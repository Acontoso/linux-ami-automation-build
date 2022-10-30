resource "aws_kms_key" "secrets_key" {
  description              = "Key used to encrypt secrets stored in Github"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  tags                     = local.tags
}

resource "aws_kms_alias" "alias_secrets_key" {
  name          = "alias/terraform-secrets"
  target_key_id = aws_kms_key.secrets_key.id
}
