#!/bin/bash

# Change group from root to Default Users = 2000
chown  root:2000 /usr/bin/ssh
# Change rights to rwxr-x---
chmod o-rx /usr/bin/ssh


