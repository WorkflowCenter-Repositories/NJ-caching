#!/bin/bash

set -e
sourcefile=$1
dest=$2
blueprint=$3
container=$4

# Start Timestamp
STARTTIME=`date +%s.%N`

destDir=$(dirname "$dest")

#-----------------------------------------#
#--------------- Data copy ---------------#
sudo docker exec -it ${container} [ ! -d /root/${blueprint}/${destDir} ] && sudo docker exec -it ${container} mkdir /root/${blueprint}/${destDir}
sudo chmod -R 777 ~/${blueprint}
sudo chmod 777 ~/${blueprint}/${sourcefile}.ser

cp ~/${blueprint}/${sourcefile}.ser ~/${blueprint}/${dest}.ser
#--------------- Data copy ---------------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Copy Data to ${container} $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
