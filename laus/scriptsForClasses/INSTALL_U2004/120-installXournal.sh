#!/bin/bash

# xournalpp is a pdf-editor (annotations, graphics, LaTeX)
# added by Thomas Neuhold, 2020-06-04

export DEBIAN_FRONTEND=noninteractive

add-apt-repository -y ppa:andreasbutti/xournalpp-master
apt-get -y update
apt-get -y install xournalpp


