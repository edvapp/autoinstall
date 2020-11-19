#!/bin/bash

# apt-get -y update

# quiet installation
# install Zoom

# the deb file has to runn in the same directory!!
# https://support.zoom.us/hc/de/articles/204206269-Zoom-unter-Linux-installieren-oder-aktualisieren#h_89c268b4-2a68-4e4c-882f-441e374b87cb
cd files
sudo apt -y install ./zoom_amd64.deb
