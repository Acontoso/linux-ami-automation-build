#  SOE Build

SOE build pipeline used to build and create Linux SOE AMI's in AWS. This automation allows for an automated build process of an Ubuntu AMI that has preconfigured security tooling and software, along with hardening configuration being completed by Ansible playbooks. This component aims to introduced standarized AMI's that can be used within AWS, to allow for pre-hardened and configured golden image for testing and production use on AWS EC2 compute.

### SOPS

Sops is an editor of encrypted files that support YAML, JSON, ENV and binary formats, that encrypts with AWS KMS, Azure KeyVault and other supported crypographic key pairs. This allows us to store encrypted secrets in Github/source code repository and decrypt them during terraform runtime when deploying infrastructure into the Cloud or relevant service provider.

To use sops, first create a creds.yml file, and store the creds in yaml key-value format. Once done, ensure you've authenticated into the target AWS account where the deployments will occur, and run the command below. The prerequisite tooling you require are
```
AWS CLI
Programmatic access (access-key-id and secret-access-key) to AWS
```

`aws kms encrypt --key-id <KMS Key ID> --region <KMS key region> --plaintext fileb://creds.yml --output text --query CiphertextBlob > creds.yml.encrypted`
Please NOTE, once the encrypted file has been created, please delete the creds.yml file prior to commiting to source-code repository!
