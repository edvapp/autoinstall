#!/bin/bash
#
# some user habits adaptions for finding paths to use a common cluster standards

# created by Thomas Gatterer


mkdir /home/localsave
chown user.2000 /home/localsave
chmod 755 /home/localsave

mkdir /ORTE
ln -s /home/localsave /ORTE/1.localsave
ln -s /home/shares/schueler /ORTE/3.Austauschverzeichnis

# TODO(Tomm): usw. nach Vorlage Server Gottfried
