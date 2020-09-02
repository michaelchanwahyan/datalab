# Dockerfile for building general development
# environment for Data Science Analytics
FROM ubuntu:16.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    AIRFLOW_HOME=/opt/airflow \
    AIRFLOW_GPL_UNIDECODE=yes \
    CLOUD_SDK_REPO="cloud-sdk-xenial" \
    HADOOP_COMMON_HOME=/hadoop-2.7.7 \
    HADOOP_HDFS_HOME=/hadoop-2.7.7 \
    HADOOP_HOME=/hadoop-2.7.7 \
    HADOOP_CONF_DIR=/hadoop-2.7.7/etc/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop-2.7.7/lib/native \
    HADOOP_INSTALL=/hadoop-2.7.7 \
    HADOOP_MAPRED_HOME=/hadoop-2.7.7 \
    JAVA_HOME=/jdk1.8.0_171 \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3 \
    SPARK_HOME=/spark-2.4.0-bin-hadoop2.7 \
    SPARK_PATH=/spark-2.4.0-bin-hadoop2.7 \
    YARN_HOME=/hadoop-2.7.7 \
    PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/local/lib:/usr/lib:/usr/sbin:/usr/bin:/sbin:/bin:/hadoop-2.7.7/sbin:/hadoop-2.7.7/bin:/jdk1.8.0_171/bin

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

RUN apt-get -y update ;\
    apt-get -y upgrade ;\
    apt-get -y install screen apt-utils cmake htop wget vim nano curl git \
               software-properties-common apt-transport-https net-tools \
               bc npm ca-certificates musl-dev gcc make g++ gfortran doxygen \
               imagemagick cowsay fortune sl ;\
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' ;\
    apt-get -y update ;\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 ;\
    apt-get -y update

RUN git clone https://github.com/michaelchanwahyan/jdk1.8.0_171 ;\
    git clone https://github.com/michaelchanwahyan/spark-2.4.0-bin-hadoop2.7 ;\
    git clone https://github.com/michaelchanwahyan/hadoop-2.7.7 ;\
    mkdir /gcs-connector-hadoop ;\
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list ;\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - ;\
    apt-get -y update ;\
    apt-get -y install google-cloud-sdk ;\
    wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar ;\
    mv   gcs-connector-latest-hadoop2.jar       /gcs-connector-hadoop/ ;\
    echo export     HADOOP_CLASSPATH=/gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> /hadoop-2.7.7/etc/hadoop/hadoop-env.sh ;\
    echo spark.driver.extraClassPath /gcs-connector-hadoop/gcs-connector-latest-hadoop2.jar >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.memory                    5g                                          >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.maxResultSize             5g                                          >> $SPARK_HOME/conf/spark-defaults.conf ;\
    echo spark.driver.allowMultipleContexts     True                                        >> $SPARK_HOME/conf/spark-defaults.conf

# info to hadoop                 <-- HADOOP_CLASSPATH
# info to spark                  <-- spark.driver.extraClassPath
# max mem consumed per core      <-- spark.driver.memory
# prevent rdd.collect() exceed   <-- spark.driver.maxResultSize

RUN apt-get -y update ;\
    apt-get -y install libcurl4-openssl-dev libssl-dev libeigen3-dev ;\
    apt-get -y install libgmp-dev libgmpxx4ldbl libmpfr-dev libboost-dev ;\
    apt-get -y install libboost-thread-dev libtbb-dev libflann-dev ;\
    apt-get -y install libblkid-dev e2fslibs-dev libboost-all-dev libaudit-dev ;\
    apt-get -y install freeglut3-dev libusb-1.0-0-dev libx11-dev xorg-dev ;\
    apt-get -y install libvtk6-dev ;\
    apt-get -y install libglu1-mesa-dev libgl1-mesa-glx libglew-dev libglfw3-dev ;\
    apt-get -y install libjsoncpp-dev libpng-dev libpng16-dev libjpeg-dev ;\
    apt-get -y install libudev-dev libopenni-dev libopenni2-dev ;\
    apt-get -y install libpcl-dev

# build and install Python3.6.8
RUN wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz ;\
    tar -zxvf Python-3.6.8.tgz ;\
    cd Python-3.6.8 ;\
    ./configure ;\
    make ;\
    make install ;\
    pip3 install --upgrade pip

# jupyter(lab) related python packages are
# required before installing interactive R kernel
COPY [ "requirements0.txt" , "requirements1.txt" , "requirements2.txt" , "requirements3.txt" , "requirements4.txt" , "requirements5.txt" , "/" ]
COPY [ "requirements0.txt" , "/" ]
RUN pip3 install -r requirements0.txt
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

RUN jupyter nbextension enable --py widgetsnbextension ;\
    jupyter serverextension enable --py jupyterlab
    #jupyter serverextension enable --py jupyterlab ;\
    #jupyter labextension install @jupyterlab/latex

RUN pip3 install git+https://github.com/IcarusSO/nbparameterise.git

RUN pip3 install git+https://git@github.com/ping/instagram_private_api.git@1.6.0


COPY [ ".bashrc" , ".vimrc"               , "/root/"                 ]
COPY [ "core-site.xml"                    , "$HADOOP_CONF_DIR"       ]
COPY [ "startup.sh"                       , "/"                      ]
COPY [ "airflow"                          , "/opt/airflow"           ]

EXPOSE 9090 9999
CMD [ "/bin/bash" ]
