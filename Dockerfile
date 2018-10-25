# Dockerfile for building general development
# environment for Data Science Analytics
# customized for TVB Big Data Team
FROM ubuntu:16.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    AIRFLOW_HOME=/opt/airflow \
    CLOUD_SDK_REPO="cloud-sdk-xenial" \
    HADOOP_COMMON_HOME=/hadoop-2.7.6 \
    HADOOP_HDFS_HOME=/hadoop-2.7.6 \
    HADOOP_HOME=/hadoop-2.7.6 \
    HADOOP_CONF_DIR=/hadoop-2.7.6/etc/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop-2.7.6/lib/native \
    HADOOP_INSTALL=/hadoop-2.7.6 \
    HADOOP_MAPRED_HOME=/hadoop-2.7.6 \
    JAVA_HOME=/jdk1.8.0_171 \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3 \
    SPARK_HOME=/spark-2.3.1-bin-hadoop2.7 \
    SPARK_PATH=/spark-2.3.1-bin-hadoop2.7 \
    YARN_HOME=/hadoop-2.7.6 \
    PATH=$PATH:/root/anaconda/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/hadoop-2.7.6/sbin:/hadoop-2.7.6/bin

# ========================
# Jupyter Lab installation
# ========================
# ref : https://github.com/mikebirdgeneau/jupyterlab-docker/blob/master/jupyterlab/Dockerfile
# for pip3 installation on jupyterlab related packages :
# ipywidgets   nbextension   jupyterlab

# ==================
# SPARK installation
# ==================
# ref : https://medium.com/@GalarnykMichael/install-spark-on-ubuntu-pyspark-231c45677de0
# SPARK installation - Part 1 (conda)
# SPARK installation - Part 2 (spark)
# SPARK installation - Part 3 (jdk 8.171)
# SPARK installation - Part 4 (hadoop 2.7.6)

# =============================
# Google Cloud SDK installation
# =============================
# ref : https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
#    many more gcloud packages that could be installed
#    google-cloud-sdk-app-engine-python
#    google-cloud-sdk-app-engine-python-extras
#    google-cloud-sdk-app-engine-java
#    google-cloud-sdk-app-engine-go
#    google-cloud-sdk-datalab
#    google-cloud-sdk-datastore-emulator
#    google-cloud-sdk-pubsub-emulator
#    google-cloud-sdk-cbt
#    google-cloud-sdk-bigtable-emulator
#    kubectl

COPY [ "jdk-8u171-linux-x64.tar.gz" , "/" ]

RUN mkdir /app ;\
    mkdir /gcs-connector-hadoop ;\
    apt-get -y update ;\
    apt-get -y upgrade ;\
    apt-get -y install screen apt-utils cmake htop wget vim nano curl git \
               software-properties-common apt-transport-https ;\
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' ;\
    apt-get -y update ; add-apt-repository ppa:jonathonf/python-3.6 ; apt-get -y update ;\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 ;\
    apt-get -y update

RUN apt-get -y install libcurl4-openssl-dev libssl-dev ;\
    apt-get -y update ;\
    apt-get -y install r-base bc nodejs ca-certificates musl-dev gcc make g++ gfortran python3.6

RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6 ;\
    rm -f /usr/bin/python3  && ln -s /usr/bin/python3.6  /usr/bin/python3 ;\
    rm -f /usr/bin/python3m && ln -s /usr/bin/python3.6m /usr/bin/python3m ;\
    apt-get -y install python3.6-dev ; apt-get -y upgrade ; apt-get -y install python3.6-tk cowsay fortune sl

COPY [ "requirements1.txt" , "/" ]
RUN pip3 install -r requirements1.txt

COPY [ "requirements2.txt" , "/" ]
RUN pip3 install -r requirements2.txt

COPY [ "requirements3.txt" , "/" ]
RUN pip3 install -r requirements3.txt

COPY [ "requirements4.txt" , "/" ]
RUN pip3 install -r requirements4.txt

COPY [ "requirements5.txt" , "/" ]
RUN pip3 install -r requirements5.txt

RUN R -e 'install.packages("devtools")' ;\
    R -e 'devtools::install_github("IRkernel/IRkernel")' ;\
    R -e 'IRkernel::installspec()' ;\
    R -e 'install.packages("bayesAB")' ;\
    R -e 'install.packages("plyr")' ;\
    R -e 'install.packages("dplyr")' ;\
    R -e 'install.packages("data.table")' ;\
    R -e 'install.packages("bigrquery")' ;\
    R -e 'install.packages("pwr")' ;\
    R -e 'install.packages("cowsay")' ;\
    R -e 'install.packages("fortunes")' ;\
    R -e 'install.packages("progress")' ;\
    R -e 'install.packages("ggplot2")' ;\
    R -e 'install.packages("forecast")'

RUN jupyter nbextension enable --py widgetsnbextension ;\
    jupyter serverextension enable --py jupyterlab

RUN tar  -zxvf jdk-8u171-linux-x64.tar.gz ;\
    rm   -f    jdk-8u171-linux-x64.tar.gz

#RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh ;\
#    bash Anaconda3-5.0.1-Linux-x86_64.sh -b -p ~/anaconda ;\
#    rm   -f  Anaconda3-5.0.1-Linux-x86_64.sh

RUN wget http://www-us.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz ;\
    tar  -zxvf spark-2.3.1-bin-hadoop2.7.tgz ;\
    rm   -f    spark-2.3.1-bin-hadoop2.7.tgz

RUN wget http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.6/hadoop-2.7.6.tar.gz ;\
    tar  -zxvf hadoop-2.7.6.tar.gz ;\
    rm   -f    hadoop-2.7.6.tar.gz

RUN echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list ;\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - ;\
    apt-get -y update ;\
    apt-get -y install google-cloud-sdk ;\
    wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar ;\
    mv   gcs-connector-latest-hadoop2.jar       /gcs-connector-hadoop/ ;\
    echo export     HADOOP_CLASSPATH=/gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> /hadoop-2.7.6/etc/hadoop/hadoop-env.sh ;\
    echo spark.driver.extraClassPath /gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.memory                    5g                                          >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.maxResultSize             5g                                          >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.allowMultipleContexts     True                                        >> $SPARK_HOME/conf/spark-defaults.conf

# info to hadoop                 <-- HADOOP_CLASSPATH
# info to spark                  <-- spark.driver.extraClassPath
# max mem consumed per core      <-- spark.driver.memory
# prevent rdd.collect() exceed   <-- spark.driver.maxResultSize

COPY [ ".bashrc" , ".vimrc"               , "/root/"                 ]
COPY [ "core-site.xml"                    , "$HADOOP_CONF_DIR"       ]
COPY [ "startup.sh"                       , "/"                      ]
COPY [ "airflow"                          , "/opt/airflow"           ]

EXPOSE 9090 9999
CMD [ "/bin/bash" ]
