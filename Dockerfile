# Dockerfile for building general development
# environment for Data Science Analytics
FROM ubuntu:20.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    AIRFLOW_HOME=/app/airflow \
    AIRFLOW_GPL_UNIDECODE=yes \
    HADOOP_COMMON_HOME=/hadoop-3.2.0 \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop-3.2.0/lib/native \
    HADOOP_CONF_DIR=/hadoop-3.2.0/etc/hadoop \
    HADOOP_HDFS_HOME=/hadoop-3.2.0 \
    HADOOP_HOME=/hadoop-3.2.0 \
    HADOOP_INSTALL=/hadoop-3.2.0 \
    HADOOP_MAPRED_HOME=/hadoop-3.2.0 \
    JAVA_HOME=/jdk1.8.0_171 \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3 \
    SPARK_HOME=/spark-3.2.0-bin-hadoop3.2 \
    SPARK_PATH=/spark-3.2.0-bin-hadoop3.2 \
    PATH=$PATH:/bin:/cmake-3.22.1-linux-x86_64/bin:/hadoop-2.7.7/bin:/hadoop-2.7.7/sbin:/jdk1.8.0_171/bin:/sbin:/usr/bin:/usr/lib:/usr/local/bin:/usr/local/lib:/usr/local/sbin:/usr/local/sbin:/usr/sbin

RUN apt-get -y update
RUN apt-get -y install \
        apt-transport-https \
        apt-utils \
        bc \
        curl \
        gcc \
        git \
        htop \
        make \
        nano \
        net-tools \
        screen \
        vim \
        wget

RUN cd / ;\
    wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.tar.gz ;\
    tar -zxvf cmake-3.22.1-linux-x86_64.tar.gz
RUN cd / ;\
    git clone https://github.com/michaelchanwahyan/jdk1.8.0_171 
#RUN cd / ;\
#    wget https://archive.apache.org/dist/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz ;\
#    tar -zxvf hadoop-3.2.0.tar.gz
#RUN cd / ;\
#    wget https://archive.apache.org/dist/hadoop/common/hadoop-3.2.0/hadoop-3.2.0-src.tar.gz ;\
#    tar -zxvf hadoop-3.2.0-src.tar.gz
RUN cd / ;\
    wget https://dlcdn.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz ;\
    tar -zxvf spark-3.2.0-bin-hadoop3.2.tgz

# prerequisites of Python 3.8
RUN apt-get -y install \
        build-essential \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libgdbm-dev \
        libncursesw5-dev \
        libreadline-gplv2-dev \
        libsqlite3-dev \
        libssl-dev \
        openssl \
        zlib1g-dev
# build Python 3.8.12
# option --disable-test-modules : Install Options
# option --without-doc-strings  : Performance Options
RUN cd / ;\
    wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz ;\
    tar -zxvf Python-3.8.12.tgz
RUN cd /Python-3.8.12 ;\
    ./configure --disable-test-modules --without-doc-strings ;\
    make ;\
    make install

RUN pip3 install --upgrade pip
 
RUN pip3 install \
        pyarrow==6.0.1
RUN PYSPARK_HADOOP_VERSION=3.2 pip3 install pyspark

RUN pip3 install \
        ipython==7.30.1 \
        ipython-genutils==0.2.0 \
        jupyter==1.0.0 \
        jupyter-client==7.1.0 \
        jupyter-console==6.4.0 \
        jupyter-core==4.9.1 \
        jupyter-server==1.13.1 \
        jupyterlab==3.2.5 \
        jupyterlab-launcher==0.13.1 \
        jupyterlab-pygments==0.1.2 \
        jupyterlab-server==2.8.2 \
        jupyterlab-widgets==1.0.2

RUN pip3 install \
        cython==0.29.25 \
        matplotlib==3.3.1 \
        numpy==1.21.4 \
        pandas==1.3.4 \
        pillow==8.4.0 \
        scikit-image==0.19.0 \
        scikit-learn==1.0.1 \
        scipy==1.7.3

RUN pip3 install \
        torch==1.10.0+cpu \
        torchaudio==0.10.0+cpu \
        torchvision==0.11.1+cpu \
        -f https://download.pytorch.org/whl/cpu/torch_stable.html

RUN pip3 install \
        anytree==2.8.0 \
        arrow==1.2.1 \
        cvxpy==1.1.17 \
        django-file-md5==1.0.3 \
        ecos==2.0.8 \
        gensim==4.1.2 \
        h5py==3.6.0 \
        jieba==0.42.1 \
        laspy==2.0.3 \
        lxml==4.7.0 \
        multiprocess==0.70.12.2 \
        networkx==2.6.3 \
        nltk==3.6.4 \
        opencv-python==4.5.4.60 \
        osqp==0.6.2.post0 \
        pattern3==3.0.0 \
        plotly==5.4.0 \
        plyfile==0.7.4 \
        scs==2.1.4 \
        toolz==0.11.2

RUN DEBIAN_FRONTEND=nointeract \
    apt-get -y install --no-install-recommends \
        freetds-bin \
        krb5-user \
        ldap-utils \
        libsasl2-2 \
        libsasl2-modules \
        libssl1.1 \
        locales  \
        lsb-release \
        sasl2-bin \
        sqlite3 \
        unixodbc

# install airflow
# airflow needs a home. '/app/airflow' is now set as $AIRFLOW_HOME
# AIRFLOW_VERSION=2.0.1
# PYTHON_VERSION=3.8
# CONSTRAINT_URL=
# https://raw.githubusercontent.com/apache/
#         airflow/constraints-${AIRFLOW_VERSION}/
#         constraints-${PYTHON_VERSION}.txt"
RUN pip3 install apache-airflow==2.0.1 \
    --constraint https://raw.githubusercontent.com/apache/airflow/constraints-2.0.1/constraints-3.8.txt

RUN mkdir -p /app/airflow/dags
COPY ["startup.sh", "/"]
COPY [".bashrc", ".vimrc", "/root/"]
COPY ["airflow/dags/first-airflow-tutorial.py", "/app/airflow/dags/"]
EXPOSE 8080 9090 9999

CMD [ "/bin/bash" ]
