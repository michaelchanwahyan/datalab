#!/bin/sh
clear


mkdir -p /app
sudo chown -R $(whoami) /app ; 
sudo chmod u+rwx /app
if ls /app/startup;
	then echo "";
	else cp -r ./app_template/startup /app/startup;
fi;

if ls /app/dags;
	then echo "";
	else cp -r ./app_template/dags /app/dags;
fi;

if ls /app/ws-alpha;
	then echo "";
	else cp -r ./app_template/ws-alpha /app/ws-alpha;
fi;


export TZ=Asia/Hong_Kong
apt install bc
docker rm -f ds_workspace
mem=$(free -g | head -2 | tail -1 | awk -F " " '{print $2}') # if you run to error, set mem to your system memory (in GB unit)
target_mem=$(echo "$mem * 0.9" | bc) # if you run to error, install bc
if [ -z "$target_mem" ]; then
    target_mem=4
fi
docker run -p 9999:9999 \
           -p 9090:9090 \
           -v /app:/app \
           -dt \
           --name=ds_workspace \
           --memory="$target_mem"g \
           datalab:stable \
           /bin/bash /app/startup/startup.sh
