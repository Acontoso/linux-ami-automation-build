#!/bin/bash
source /usr/local/sbin/install_ssm.sh
wait $!
systemctl disable ssm_install.service
rm -f /usr/local/sbin/install_defender.sh
rm -f /etc/systemd/system/ssm_install.service
