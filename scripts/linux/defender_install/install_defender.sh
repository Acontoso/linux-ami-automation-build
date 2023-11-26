#!/bin/bash
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
    VERSION_NAME=$VERSION_CODENAME
fi

if [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "ubuntu" ]; then
    DISTRO_FAMILY="debian"
elif [ "$DISTRO" == "rhel" ] || [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "ol" ] || [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "amzn" ]; then
    DISTRO_FAMILY="fedora"
elif [ "$DISTRO" == "sles" ] || [ "$DISTRO" == "sle-hpc" ] || [ "$DISTRO" == "sles_sap" ]; then
    DISTRO_FAMILY="sles"
elif [ "$DISTRO" == "mariner" ]; then
    DISTRO_FAMILY="mariner"
else
    script_exit "unsupported distro $DISTRO $VERSION" $ERR_UNSUPPORTED_DISTRO
fi

echo ${DISTRO}
echo ${VERSION}
echo ${VERSION_NAME}
echo ${DISTRO_FAMILY}

curl -o microsoft.list https://packages.microsoft.com/config/${DISTRO}/${VERSION}/prod.list
mv ./microsoft.list /etc/apt/sources.list.d/microsoft-prod.list
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
sleep 10
FAILURE_COUNT=0
while (( $FAILURE_COUNT < 3 )); do
    apt-get update && apt-get -y install mdatp
    status=$?
    if [ $status -ne 0 ]; then
        sleep 10
        (( FAILURE_COUNT++ ))
    else
        break
    fi
done
if (( $FAILURE_COUNT == 3 )); then
    exit 125
fi
wait
cd /usr/local/sbin
unzip WindowsDefenderATPOnboardingPackage.zip
rm WindowsDefenderATPOnboardingPackage.zip
python3 MicrosoftDefenderATPOnboardingLinuxServer.py
wait $!
rm MicrosoftDefenderATPOnboardingLinuxServer.py
mv mdatp_managed.json /etc/opt/microsoft/mdatp/managed/.
