#!/bin/sh
clear
docker rm -f sleepy_pikachu
docker run -p 9999:9999            \
           -p 9090:9090            \
           -v /app:/app            \
           -dt                     \
           --name=sleepy_pikachu   \
           --memory=90g            \
           datalab:stable          \
           /bin/bash    /startup.sh
