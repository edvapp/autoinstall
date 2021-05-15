#!/bin/bash

## For network users
## evince GUI - input - dialogs are blocked by apparmor profile
## so we disable profile for evince

ln -s /etc/apparmor.d/usr.bin.evince /etc/apparmor.d/disable/usr.bin.evince
