#!/bin/sh
clear
export TZ=Asia/Hong_Kong
mkdir -p /app/logs
docker rm -f sleepy_pichu
mem=$(free -g | head -2 | tail -1 | awk -F " " '{print $2}') # if you run to error, set mem to your system memory (in GB unit)
#mem=8
target_mem=$(echo "$mem * 0.9" | bc) # if you run to error, install bc
docker run -p 9999:9999 \
           -v /app:/app \
           -dt \
           --name=sleepy_pichu \
           --memory="$target_mem"g \
           datalab:lightstable \
           /bin/bash /startup.sh
