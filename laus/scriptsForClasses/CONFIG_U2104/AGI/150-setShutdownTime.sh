#!/bin/bash

## IMPORTANT:
## shutDownAt18Clock may NOT be named shutDownAt18Clock.sh
## #!/bin/bash has to be in FIRST LINE

echo '#! /bin/bash

CURRENT_HOUR=$(date +%H)
if [ $CURRENT_HOUR -eq "18" ];
then
	systemctl poweroff
fi
' > /etc/cron.hourly/shutDownAt18Clock

chmod 755 /etc/cron.hourly/shutDownAt18Clock
