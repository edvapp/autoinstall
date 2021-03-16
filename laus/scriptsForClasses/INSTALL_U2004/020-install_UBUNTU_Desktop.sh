#!/bin/bash

#apt-get -y update

# quiet installation
export DEBIAN_FRONTEND=noninteractive

## Full Ubuntu - GNOME - Desktop
## german language packs
## dconf-editor: editor to customize hidden desktop options
## gnome-shell-extension: program to control shell extensions
## compizconfig-settings-manager: more Settings for Compiz Graphic Manager
## chrome-gnome-shell: backend to install gnome-extensions via browser
## firefox-locale-de: german language pack firefox
## mc: Midnight commander
apt-get -y install ubuntu-desktop language-pack-de-base language-pack-de language-pack-gnome-de-base language-pack-gnome-de dconf-editor gnome-shell-extensions compizconfig-settings-manager chrome-gnome-shell firefox-locale-de mc
