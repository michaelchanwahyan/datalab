#!/bin/sh

export TZ=Asia/Hong_Kong

# load dag configuration
mkdir -p /app/dags

if ls /app/startup;
	then echo 'installed';
	else
		mkdir -p /app/startup;
		cp /startup/quick_install.sh /app/startup/quick_install.sh;
fi

# git set to only push "current"
# + only "with same branch name"
git config --global push.default simple

### # --------------------
### # gcp configuration
### # --------------------
###
### # gcp client service account set up for shell env
### gcloud   auth   activate-service-account   --quiet   --key-file=/path/to/your/gcp/credential.json
###
### # gcp client service account set up for python env
### # no need because it is embedded into Dockerfile
### # export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/credential.json


# --------------------
# Install libraries
# --------------------
mkdir -p /app/lib;
/bin/bash /app/startup/quick_install.sh

# --------------------
# Jupyter Lab
# --------------------
screen -S jupyter_lab -dm jupyter lab --ip=0.0.0.0 --port=9999 --no-browser --notebook-dir=/app --allow-root --NotebookApp.token='dsteam' ;

# --------------------
# Airflow
# --------------------
airflow initdb
screen -S airflow_webservice -dm airflow webserver
screen -S scheduler -dm airflow scheduler

printenv >> /etc/environment;

bash
