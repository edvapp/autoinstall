#!/bin/bash
VERSION=$(vboxmanage -v)
echo ${VERSION}
VERSION_NUMBER=$(echo $VERSION | cut -d '_' -f 1)
echo ${VERSION_NUMBER}
file="Oracle_VM_VirtualBox_Extension_Pack-${VERSION_NUMBER}.vbox-extpack"
echo $file
wget download.virtualbox.org/virtualbox/${VERSION_NUMBER}/${file} -O /tmp/${file}

VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"
#VBoxManage extpack install /tmp/${file} --replace --accept-license=56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb
# new license key: 2021.03.06
VBoxManage extpack install /tmp/${file} --replace --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c
