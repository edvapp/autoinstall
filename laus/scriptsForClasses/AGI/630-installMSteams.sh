#!/bin/bash

#apt-get -y update

# quiet installation
# install ms-teams
cd /tmp
VERSION=1.3.00.5153
sudo wget https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${VERSION}_amd64.deb
sudo apt install ./teams_${VERSION}_amd64.deb
