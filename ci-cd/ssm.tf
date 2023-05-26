resource "aws_ssm_parameter" "cs_client_id" {
  #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
  name      = "/crowdstrike/client_id"
  type      = "SecureString"
  value     = local.secrets.cs_client_id
  overwrite = true
  tags      = local.tags
}

resource "aws_ssm_parameter" "cs_client_secret" {
  #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
  name      = "/crowdstrike/client_secret"
  type      = "SecureString"
  value     = local.secrets.cs_client_secret
  overwrite = true
  tags      = local.tags
}
