# Dockerfile for building general development
# environment for Data Science Analytics
# customized for TVB Big Data Team
FROM ubuntu:16.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV AIRFLOW_HOME=/opt/airflow                                               \
    SHELL=/bin/bash                                                         \
    CLOUD_SDK_REPO="cloud-sdk-xenial"                                       \
    HADOOP_COMMON_HOME=/hadoop-2.7.6                                        \
    HADOOP_HDFS_HOME=/hadoop-2.7.6                                          \
    HADOOP_HOME=/hadoop-2.7.6                                               \
    HADOOP_CONF_DIR=/hadoop-2.7.6/etc/hadoop                                \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop-2.7.6/lib/native                   \
    HADOOP_INSTALL=/hadoop-2.7.6                                            \
    HADOOP_MAPRED_HOME=/hadoop-2.7.6                                        \
    JAVA_HOME=/jdk1.8.0_171                                                 \
    PYSPARK_DRIVER_PYTHON="jupyter"                                         \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook"                                   \
    PYSPARK_PYTHON=python3                                                  \
    SPARK_HOME=/spark-2.3.1-bin-hadoop2.7                                   \
    SPARK_PATH=/spark-2.3.1-bin-hadoop2.7                                   \
    YARN_HOME=/hadoop-2.7.6                                                 \
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

RUN mkdir /app                                                                                           ; \
    mkdir -p /opt/airflow                                                                                ; \
    mkdir /gcs-connector-hadoop                                                                          ; \
    apt-get -y update                                                                                    ; \
    apt-get -y upgrade                                                                                   ; \
    apt-get -y install screen                                                                            ; \
    apt-get -y install apt-utils                                                                         ; \
    apt-get -y install cmake                                                                             ; \
    apt-get -y install htop                                                                              ; \
    apt-get -y install wget                                                                              ; \
    apt-get -y install vim                                                                               ; \
    apt-get -y install curl                                                                              ; \
    apt-get -y install git                                                                               ; \
    apt-get -y install software-properties-common                                                        ; \
    apt-get -y install apt-transport-https                                                               ; \
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'         ; \
    apt-get -y update                                                                                    ; \
    add-apt-repository ppa:jonathonf/python-3.6                                                          ; \
    apt-get -y update                                                                                    ; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9    ; \
    apt-get -y update                                                                                    ; \
    apt-get -y install r-base                                                                            ; \
    apt-get -y update                                                                                    ; \
    apt-get -y install nodejs                                                                            ; \
    apt-get -y install ca-certificates                                                                   ; \
    apt-get -y install musl-dev                                                                          ; \
    apt-get -y install gcc                                                                               ; \
    apt-get -y install make                                                                              ; \
    apt-get -y install g++                                                                               ; \
    apt-get -y install gfortran                                                                          ; \
    apt-get -y install python3.6                                                                         ; \
    curl https://bootstrap.pypa.io/get-pip.py | python3.6                                                ; \
    rm -f /usr/bin/python3  ; ln -s /usr/bin/python3.6  /usr/bin/python3                                 ; \
    rm -f /usr/bin/python3m ; ln -s /usr/bin/python3.6m /usr/bin/python3m                                ; \
    apt-get -y install python3.6-dev                                                                     ; \
    apt-get -y upgrade                                                                                   ; \
    apt-get -y install cowsay                                                                            ; \
    apt-get -y install fortune                                                                           ; \
    apt-get -y install sl                                                                                ; \
    pip3       install numpy                                                                             ; \
    pip3       install scipy                                                                             ; \
    pip3       install matplotlib                                                                        ; \
    pip3       install pandas                                                                            ; \
    pip3       install sklearn                                                                           ; \
    pip3       install gensim                                                                            ; \
    pip3       install h5py                                                                              ; \
    pip3       install pillow                                                                            ; \
    pip3       install arrow                                                                             ; \
    pip3       install pattern3                                                                          ; \
    pip3       install django-file-md5                                                                   ; \
    pip3       install tensorflow                                                                        ; \
    pip3       install keras                                                                             ; \
    pip3       install pyspark                                                                           ; \
    pip3       install findspark                                                                         ; \
    pip3       install pymysql                                                                           ; \
    pip3       install airflow                                                                           ; \
    pip3       install slackclient                                                                       ; \
    pip3       install cython                                                                            ; \
    pip3       install folium                                                                            ; \
    pip3       install lxml                                                                              ; \
    pip3       install nltk                                                                              ; \
    pip3       install implicit                                                                          ; \
    pip3       install setuptools                                                                        ; \
    pip3       install toolz                                                                             ; \
    pip3       install six                                                                               ; \
    pip3       install fastcache                                                                         ; \
    pip3       install multiprocess                                                                      ; \
    pip3       install OSQP                                                                              ; \
    pip3       install ECOS                                                                              ; \
    pip3       install SCS                                                                               ; \
    pip3       install cvxpy                                                                             ; \
    pip3       install jupyter                                                                           ; \
    pip3       install ipywidgets                                                                        ; \
    jupyter    nbextension           enable --py widgetsnbextension                                      ; \
    jupyter    serverextension       enable --py jupyterlab                                              ; \
    pip3       install jupyterlab                                                                        ; \
    tar  -zxvf jdk-8u171-linux-x64.tar.gz                                                                ; \
    rm   -f    jdk-8u171-linux-x64.tar.gz                                                                ; \
    wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh                               ; \
    bash Anaconda3-5.0.1-Linux-x86_64.sh -b -p ~/anaconda                                                ; \
    rm   -f  Anaconda3-5.0.1-Linux-x86_64.sh                                                             ; \
    wget http://www-us.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz                   ; \
    tar  -zxvf spark-2.3.1-bin-hadoop2.7.tgz                                                             ; \
    rm   -f    spark-2.3.1-bin-hadoop2.7.tgz                                                             ; \
    wget http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.6/hadoop-2.7.6.tar.gz                    ; \
    tar  -zxvf hadoop-2.7.6.tar.gz                                                                       ; \
    rm   -f    hadoop-2.7.6.tar.gz                                                                       ; \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main"                                ; \
         tee -a /etc/apt/sources.list.d/google-cloud-sdk.list                                            ; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg                                           | \
         apt-key add -                                                                                   ; \
    apt-get -y update                                                                                    ; \
    apt-get -y install google-cloud-sdk                                                                  ; \
    wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar                  ; \
    mv   gcs-connector-latest-hadoop2.jar       /gcs-connector-hadoop/                                   ; \
    echo export     HADOOP_CLASSPATH=/gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> /hadoop-2.7.6/etc/hadoop/hadoop-env.sh ; \
    echo spark.driver.extraClassPath /gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> $SPARK_HOME/conf/spark-defaults.conf   ; \
    echo spark.driver.memory                    5g                                          >> $SPARK_HOME/conf/spark-defaults.conf   ; \
    echo spark.driver.maxResultSize             5g                                          >> $SPARK_HOME/conf/spark-defaults.conf   ; \
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
