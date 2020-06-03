#!/bin/bash

## IMPORTANT:
## shutDownAt22Clock may NOT be named shutDownAt22Clock.sh
## #!/bin/bash has to be in FIRST LINE

echo '#! /bin/bash

CURRENT_HOUR=$(date +%H)
if [ $CURRENT_HOUR -eq "22" ];
then
	systemctl poweroff
fi
' > /etc/cron.hourly/shutDownAt22Clock

chmod 755 /etc/cron.hourly/shutDownAt22Clock
