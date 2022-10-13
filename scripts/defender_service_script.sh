#!/bin/bash
source /usr/local/sbin/install_defender.sh
wait $!
systemctl disable defender_install.service
rm -f /usr/local/sbin/install_defender.sh
