#!/bin/bash

set -euxo pipefail

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive

while ! sudo grep "Cloud-init .* finished" /var/log/cloud-init.log; do
    echo "$(date -Ins) Waiting for cloud-init to finish"
    sleep 5
done

##### Ubuntu #####
# Ensure all required repositories are set
mv /etc/apt/sources.list /etc/apt/sources.bak
touch /etc/apt/sources.list

DISTRO_NAME=$(lsb_release --codename --short)
CPU_ARCH=$(uname --machine)
REPOS="main restricted universe multiverse"

if [[ "${CPU_ARCH}" == "x86_64" ]]; then
  # Australia
  add-apt-repository -y "deb http://ap-southeast-2.ec2.archive.ubuntu.com/ubuntu ${DISTRO_NAME} ${REPOS}"
  add-apt-repository -y "deb http://ap-southeast-2.ec2.archive.ubuntu.com/ubuntu ${DISTRO_NAME}-updates ${REPOS}"
  add-apt-repository -y "deb http://ap-southeast-2.ec2.archive.ubuntu.com/ubuntu ${DISTRO_NAME}-security ${REPOS}"
  # Non-AWS
  add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu ${DISTRO_NAME} ${REPOS}"
  add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu ${DISTRO_NAME}-updates ${REPOS}"
  add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu ${DISTRO_NAME}-security ${REPOS}"
  add-apt-repository -y "deb http://security.ubuntu.com/ubuntu ${DISTRO_NAME}-security ${REPOS}"
elif [[ "${CPU_ARCH}" == "aarch64" ]]; then
  # Australia
	add-apt-repository -y "deb http://ap-southeast-2.clouds.ports.ubuntu.com/ubuntu-ports ${DISTRO_NAME} ${REPOS}"
	add-apt-repository -y "deb http://ap-southeast-2.clouds.ports.ubuntu.com/ubuntu-ports ${DISTRO_NAME}-updates ${REPOS}"
	add-apt-repository -y "deb http://ap-southeast-2.clouds.ports.ubuntu.com/ubuntu-ports ${DISTRO_NAME}-security ${REPOS}"
  # Non-AWS
  add-apt-repository -y "deb http://ports.ubuntu.com/ubuntu-ports ${DISTRO_NAME} main ${REPOS}"
  add-apt-repository -y "deb http://ports.ubuntu.com/ubuntu-ports ${DISTRO_NAME}-updates ${REPOS}"
  add-apt-repository -y "deb http://ports.ubuntu.com/ubuntu-ports ${DISTRO_NAME}-security ${REPOS}"
else
  echo "CPU architecture not supported"
  exit 1
fi

apt-get update && apt-get upgrade -y

apt-get install -y python3 python3-pip python-is-python3
pip install -U pip

# Install anything else required
apt-get install -y -f \
	auditd \
	chrony \
	curl \
	htop \
	jq \
	python3-apt \
	python-apt-common \
	tree \
	unzip \
  libplist-utils \
  apt-transport-https

echo "y" | pip3 install ansible

#Install AWS cli
if [[ "${CPU_ARCH}" == "x86_64" ]]; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  ./aws/install -b /usr/local/bin
  wait
  rm -rf aws
  rm -rf awscliv2.zip
elif [[ "${CPU_ARCH}" == "aarch64" ]]; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  ./aws/install -b /usr/local/bin
  wait
  rm -rf aws
  rm -rf awscliv2.zip
else
  echo "CPU architecture not supported"
  exit 1
fi
