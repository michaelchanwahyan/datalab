#!/bin/sh
# set time zone
export TZ=Asia/Hong_Kong

# init cron, dir for airflow, data and projects
echo $(date) make dir for jupyterlab and airflow ... > /stauts
mkdir -p /app/airflow
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
cd /app/airflow
echo $(date) airflow initialization ... >> /status
airflow db init
#mv airflow.cfg airflow.cfg.tmp1
#cat airflow.cfg.tmp1 | sed 's/load_examples = True/load_examples = False/' > airflow.cfg
#yes y | airflow db reset
echo $(date) airflow admin user creation ... >> /status
airflow users create --username admin --firstname Peter --lastname Parker --role Admin --email this_is_a_dummy_admin@this_is_a_dummy_admin.org --password dsteam
echo $(date) airflow start webserver ... >> /status
screen -S airflow_webserver -dm airflow webserver              --port 9090
sleep 10
echo $(date) airflow start scheduler ... >> /status
screen -S airflow_scheduler -dm airflow scheduler
echo $(date) done !!! >> /status
# hold up the command session for docker container to remain
bash
