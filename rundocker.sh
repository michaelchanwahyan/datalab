#!/bin/sh
clear
docker rm -f ds_workspace
docker run -p 9999:9999 \
           -p 9090:9090 \
           -v /app:/app \
           -dt \
           --name=ds_workspace \
           --memory=4g \
           ds_workspace:stable \
           /usr/bin/bash /startup.sh
