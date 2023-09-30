#!/bin/bash

#install scripts (ssm, defender)

chmod +x /tmp/install_ssm_agent/install_ssm.sh
chown root:root /tmp/install_ssm_agent/install_ssm.sh

chmod +x /tmp/install_ssm_agent/ssm_service_systemd_script.sh
chown root:root /tmp/install_ssm_agent/ssm_service_systemd_script.sh

chmod +x /tmp/defender_install/install_defender.sh
chown root:root /tmp/defender_install/install_defender.sh

chmod +x /tmp/defender_install/defender_service_script.sh
chown root:root /tmp/defender_install/defender_service_script.sh

#move install scripts to sbin
mv /tmp/install_ssm_agent/install_ssm.sh /usr/local/sbin/.
mv /tmp/defender_install/install_defender.sh /usr/local/sbin/.
mv /tmp/defender_install/defender_service_script.sh /usr/local/sbin/.
mv /tmp/defender_install/WindowsDefenderATPOnboardingPackage.zip /usr/local/sbin/.

#move systemd scripts to sbin
mv /tmp/install_ssm_agent/ssm_service_systemd_script.sh /usr/local/sbin/.
mv /tmp/defender_install/defender_service_script.sh /usr/local/sbin/.

#move service unit files to systemd/system/ dir
mv /tmp/install_ssm_agent/ssm_service_script.service /etc/systemd/system/.
mv /tmp/defender_install/defender_install.service /etc/systemd/system/.
