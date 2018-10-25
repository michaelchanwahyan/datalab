#!/bin/sh

export TZ=Asia/Hong_Kong

# load cron configuration
mkdir -p /app/cron ; touch /app/cron/cron.config
crontab /app/cron/cron.config

# git set to only push "current"
# + only "with same branch name"
git config --global push.default simple

# --------------------
# gcp configuration
# --------------------

# gcp client service account set up for shell env
gcloud   auth   activate-service-account   --quiet   --key-file=/path/to/your/gcp/credential.json

# gcp client service account set up for python env
# no need because it is embedded into Dockerfile
# export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/credential.json

# --------------------
# core libraries
# --------------------

mkdir -p /app/lib ;

pushd /app/lib                                                 ; date >> /status ; echo git clone bigQueryExporter >> /status ;
git  clone  https://github.com/IcarusSO/bigQueryExporter.git                                                          ; popd  ;
pushd /app/lib/bigQueryExporter ; rm -f bigQueryExporter/.git* ; date >> /status ; pwd >> /status ; pip3 install -e . ; popd  ;

pushd /app/lib                                                 ; date >> /status ; echo git clone nbparameterise   >> /status ;
git  clone  https://github.com/IcarusSO/nbparameterise.git                                                            ; popd  ;
pushd /app/lib/nbparameterise   ; rm -f nbparameterise/.git*   ; date >> /status ; pwd >> /status ; pip3 install -e . ; popd  ;

pushd /app/lib                                                 ; date >> /status ; echo git clone dsutil           >> /status ;
git  clone  https://github.com/IcarusSO/dsutil.git                                                                    ; popd  ;
pushd /app/lib/dsutil           ; rm -f dsutil/.git*           ; date >> /status ; pwd >> /status ; pip3 install -e . ; popd  ;

# --------------------
# Jupyter Lab
# --------------------

date >> /status
echo jupyter lab screening is starting >> /status
screen -S jupyter_lab -dm jupyter lab --ip=0.0.0.0 --port=9999 --no-browser --notebook-dir=/app --allow-root --NotebookApp.token='dsteam' ;
date >> /status
echo jupyter lab screening has been started >> /status

# --------------------
# Airflow
# --------------------

date                                           >> /status ;
echo airflow initdb and webserver is starting  >> /status ;
airflow initdb
screen -S airflow_webservice -dm airflow webserver
screen -S scheduler -dm airflow scheduler
date                                           >> /status ;
echo airflow has been started                  >> /status ;
echo done in startup.sh !                      >> /status ;

printenv >> /etc/environment ; cron

bash
