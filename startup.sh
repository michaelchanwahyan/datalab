#!/bin/sh
# set time zone
export TZ=Asia/Hong_Kong

# init cron, dir for airflow, data and projects
mkdir -p /app/cron
mkdir -p /app/data
mkdir -p /app/projects
touch /app/cron/cron.config
crontab /app/cron/cron.config

# kick start jupyter lab
echo $(date) launch jupyterlab ... >> /status
screen -S jupyter_lab       -dm jupyter lab       --ip=0.0.0.0 --port=9999 --no-browser --notebook-dir=/app --allow-root --ServerApp.token='dsteam'

# finialize cron
printenv >> /etc/environment
cron

# start up airflow
#mv airflow.cfg airflow.cfg.tmp1
#cat airflow.cfg.tmp1 | sed 's/load_examples = True/load_examples = False/' > airflow.cfg
#yes y | airflow db reset
# hold up the command session for docker container to remain
bash
