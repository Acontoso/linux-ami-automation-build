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

## Standard Ansible Repo Structure
- Tasks: Contain the majority of the configuration logic. Essentially the entry point of the Ansible role is defined inside of a Git repo. This can include other tasks from different files. Think of this as the main.tf file in Terraform calling other modules defined elsewhere within or outside of the repo. `ansible.builtin.include_tasks`. Sequentially, this will execute the tasks in given order.
- Vars: Contains internal variables that are defined inside of a YML file. This calls `ansible.builtin.include_vars` to add vars to runtime. The `register: stat_result` key will hold the output of the ansible module call.
- Defaults/: Default variables used throughout the runbook.
- Templates/ - Jinja2 .j2 files where variables are interpolated at deploy time. Mainly for configuration files to deploy at runtime.
- Handlers: Triggered when notified by task. Triggered by the `notify` keyword. The Notify will define the handler to call.

## j2 template syntax

```j2
########################################################################################################################
# Nessus rules
## Ref: https://community.tenable.com/s/article/What-is-the-Nessus-rules-file
########################################################################################################################

## Plugin Syntax: plugin-accept|plugin-reject id[-id_max] ##############################################################
{% if nessus_agent_rules.plugin_reject is defined %}
{% for item in nessus_agent_rules.plugin_reject %}
plugin-reject {{ item }}
{% endfor %}
{% endif %}
{% if nessus_agent_rules.plugin_accept is defined %}
{% for item in nessus_agent_rules.plugin_accept %}
plugin-accept {{ item }}
{% endfor %}
{% endif %}

## Target Syntax: accept|reject address/netmask:port[-port_max] ########################################################
{% if nessus_agent_rules.reject is defined %} #if variable/key defined
{% for item in nessus_agent_rules.reject %} # Loop through each value
reject {{ item }} #add each line item here
{% endfor %} #close forloop
{% endif %} #close if statement
{% if nessus_agent_rules.accept is defined %}
{% for item in nessus_agent_rules.accept %}
accept {{ item }}
{% endfor %}
{% endif %}

## Default Rule Syntax (if no other rules apply): default accept|reject ################################################
{% if nessus_agent_rules.default is defined%}
{{ nessus_agent_rules.default }}
{% endif %}


```
