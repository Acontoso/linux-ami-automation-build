#!/bin/bash
source /usr/local/sbin/install_ssm.sh
wait $!
systemctl disable ssm_install.service
rm -f /usr/local/sbin/install_ssm.sh
rm -f /etc/systemd/system/ssm_install.service
rm -f /etc/local/sbin/ssm_service_script.sh