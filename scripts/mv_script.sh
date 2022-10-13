#!/bin/bash

#install scripts (laa, ssm, defender)

chmod +x /tmp/install_ssm.sh
chown root:root /tmp/install_ssm.sh

chmod +x /tmp/install_defender.sh
chown root:root /tmp/install_defender.sh

#exec start systemd service scripts

chmod +x /tmp/ssm_service_systemd_script.sh
chown root:root /tmp/ssm_service_systemd_script.sh

chmod +x /tmp/defender_service_script.sh
chown root:root /tmp/defender_service_script.sh

#move install scripts to sbin
mv /tmp/install_ssm.sh /usr/local/sbin/.
mv /tmp/install_defender.sh /usr/local/sbin/.
mv /tmp/WindowsDefenderATPOnboardingPackage.zip /usr/local/sbin/.

#move systemd scripts to sbin
mv /tmp/ssm_service_systemd_script.sh /usr/local/sbin/.
mv /tmp/defender_service_script.sh /usr/local/sbin/.

#move service unit files to systemd/system/ dir
mv /tmp/ssm_service_script.service /etc/systemd/system/.
mv /tmp/defender_install.service /etc/systemd/system/.
