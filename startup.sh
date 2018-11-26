#!/bin/sh

export TZ=Asia/Hong_Kong

# load cron configuration
mkdir -p /app/cron ; touch /app/cron/cron.config
crontab /app/cron/cron.config

# git set to only push "current"
# + only "with same branch name"
git config --global push.default simple

# --------------------
# Jupyter Lab
# --------------------

date >> /status
echo jupyter lab screening is starting >> /status
screen -S jupyter_lab -dm jupyter lab --ip=0.0.0.0 --port=9999 --no-browser --notebook-dir=/app --allow-root --NotebookApp.token='dsteam' ;
date >> /status
echo jupyter lab screening has been started >> /status

echo done in startup.sh !                      >> /status ;

printenv >> /etc/environment ; cron

bash
