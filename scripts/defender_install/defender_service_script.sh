#!/bin/bash
source /usr/local/sbin/install_defender.sh
wait $!
systemctl disable defender_install.service
rm -f /usr/local/sbin/install_defender.sh
rm -f /etc/systemd/system/defender_install.service
