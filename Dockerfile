# Dockerfile for building general development
# environment for Data Science Analytics
FROM ubuntu:22.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    AIRFLOW_HOME=/app/airflow \
    AIRFLOW_GPL_UNIDECODE=yes \
    CMAKE_PATH=/cmake-3.25.3-linux-x86_64 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3 \
    PYTHONPATH=/spark-3.3.2-bin-without-hadoop/python:/spark-3.3.2-bin-without-hadoop/python/lib/py4j-0.10.9.5-src.zip \
    R_PATH=/opt/R/4.1.3 \
    SPARK_HOME=/spark-3.3.2-bin-without-hadoop \
    SPARK_PATH=/spark-3.3.2-bin-without-hadoop \
    HADOOP_HOME=/hadoop-3.3.4/ \
    SPARK_DIST_CLASSPATH=/hadoop-3.3.4/etc/hadoop:/hadoop-3.3.4/share/hadoop/common/lib/*:/hadoop-3.3.4/share/hadoop/common/*:/hadoop-3.3.4/share/hadoop/hdfs:/hadoop-3.3.4/share/hadoop/hdfs/lib/*:/hadoop-3.3.4/share/hadoop/hdfs/*:/hadoop-3.3.4/share/hadoop/mapreduce/*:/hadoop-3.3.4/share/hadoop/yarn:/hadoop-3.3.4/share/hadoop/yarn/lib/*:/hadoop-3.3.4/share/hadoop/yarn/* \
    PATH=/usr/local/bin:/bin:/usr/bin:/lib:/lib64:/lib32:/libx32:/usr/lib:/usr/local/lib:/sbin:/usr/sbin:/usr/local/sbin:/cmake-3.25.3-linux-x86_64/bin:/opt/R/4.1.3/bin:/opt/R/4.1.3/lib:/opt/R/4.1.3/share:/usr/lib/jvm/java-8-openjdk-amd64:/spark-3.3.2-bin-without-hadoop/bin:/spark-3.3.2-bin-without-hadoop/python

RUN apt-get -y update
RUN apt-get -y install \
        apt-transport-https \
        apt-utils \
        bc \
        build-essential \
        curl \
        gcc \
        git \
        htop \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libfontconfig1-dev \
        libgdbm-dev \
        libncursesw5-dev \
        libsqlite3-dev \
        libxml2-dev \
        libssl-dev \
        make \
        nano \
        net-tools \
        openjdk-8-jdk-headless \
        openssl \
        screen \
        sqlite3 \
        vim \
        wget \
        zlib1g-dev

# ----------------------------------------------------------------------------
# build R
# ----------------------------------------------------------------------------
RUN sed -i.bak "/^#.*deb-src.*universe$/s/^# //g" /etc/apt/sources.list
RUN apt -y update ;\
    DEBIAN_FRONTEND=noninteractive \
    apt -y build-dep r-base
RUN cd / ;\
    curl -O https://cran.rstudio.com/src/base/R-4/R-4.1.3.tar.gz ;\
    tar -xzvf R-4.1.3.tar.gz
RUN cd R-4.1.3 ;\
    ./configure \
        --prefix=/opt/R/4.1.3 \
        --enable-R-shlib \
        --enable-memory-profiling \
        --with-blas \
        --with-lapack ;\
    make -j1 ;\
    make install

# ----------------------------------------------------------------------------
# install R packages and iR
# ----------------------------------------------------------------------------
RUN R -e 'install.packages(c("IRkernel"),repos="https://ftp.osuosl.org/pub/cran/")'
RUN R -e 'install.packages("devtools",repos="https://ftp.osuosl.org/pub/cran/")'
RUN R -e 'devtools::install_github("IRkernel/IRkernel@1.3.2")'

# ----------------------------------------------------------------------------
# build Python 3.10.10
# ----------------------------------------------------------------------------
# option --disable-test-modules : Install Options
# option --without-doc-strings  : Performance Options
# option --enable-optimizations
RUN cd / ;\
    wget https://www.python.org/ftp/python/3.10.10/Python-3.10.10.tgz ;\
    tar -zxvf Python-3.10.10.tgz
RUN cd Python-3.10.10 ;\
    ./configure \
        --disable-test-modules \
        --without-doc-strings \
        --enable-loadable-sqlite-extensions \
        --enable-optimizations ;\
    make -j1 ;\
    make install

# ----------------------------------------------------------------------------
# upgrade pip and install wheel
# ----------------------------------------------------------------------------
RUN pip3 install --upgrade pip ;\
    pip3 install setuptools
    pip3 install wheel

# ----------------------------------------------------------------------------
# install CMake 3.25.3
# ----------------------------------------------------------------------------
RUN cd / ;\
    wget https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3-linux-x86_64.tar.gz ;\
    tar -zxvf cmake-3.25.3-linux-x86_64.tar.gz

# ----------------------------------------------------------------------------
# install Spark 3.3.2
# ----------------------------------------------------------------------------
RUN cd / ;\
    wget https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-without-hadoop.tgz ;\
    tar -zxvf spark-3.3.2-bin-without-hadoop.tgz

# ----------------------------------------------------------------------------
# install Hadoop 3.3.4
# ----------------------------------------------------------------------------
RUN cd / ;\
    wget https://archive.apache.org/dist/hadoop/core/hadoop-3.3.4/hadoop-3.3.4.tar.gz ;\
    tar -zxvf hadoop-3.3.4.tar.gz

# ----------------------------------------------------------------------------
# install PySpark
# ----------------------------------------------------------------------------
RUN cd /spark-3.3.2-bin-without-hadoop ;\
    cd python ;\
    apt -y install python3-setuptools ;\
    pip3 install py4j ;\
    python3 setup.py sdist

# ----------------------------------------------------------------------------
# install python packages for JupyterLab and iPython
# ----------------------------------------------------------------------------
RUN pip3 install \
    ipykernel==6.21.2 \
    ipython==8.11.0 \
    ipython-genutils==0.2.0 \
    ipywidgets==8.0.4 \
    jupyter==1.0.0 \
    jupyter-console==6.6.2 \
    jupyter-events==0.6.3 \
    jupyter-ydoc==0.2.2 \
    jupyter_client==8.0.3 \
    jupyter_core==5.2.0 \
    jupyter_server==2.3.0 \
    jupyter_server_fileid==0.8.0 \
    jupyter_server_terminals==0.4.4 \
    jupyter_server_ydoc==0.6.1 \
    jupyterlab==3.6.1 \
    jupyterlab-pygments==0.2.2 \
    jupyterlab-widgets==3.0.5 \
    jupyterlab_server==2.19.0

# ----------------------------------------------------------------------------
# install R and Jupyter-integration
# this must be done after Jupyter lab is installed
# ----------------------------------------------------------------------------
RUN R -e 'IRkernel::installspec(user = FALSE)'

# ----------------------------------------------------------------------------
# install python packages
# ----------------------------------------------------------------------------
RUN pip3 install \
        cython==0.29.33 \
        matplotlib==3.7.1 \
        numpy==1.24.2 \
        pandas==1.5.3 \
        pillow==9.4.0 \
        scikit-image==0.20.0 \
        scikit-learn==1.2.2 \
        scipy==1.10.1

# pytorch-cpu 1.12.0, torchvision-cpu 0.13.0, torchtext-cpu 0.13.0, torchaudio 0.12.0
RUN pip3 install https://download.pytorch.org/whl/cpu/torch-1.12.0%2Bcpu-cp310-cp310-linux_x86_64.whl
# from https://download.pytorch.org/whl/torch/
RUN pip3 install https://download.pytorch.org/whl/cpu/torchvision-0.13.0%2Bcpu-cp310-cp310-linux_x86_64.whl
# from https://download.pytorch.org/whl/torchvision/
RUN pip3 install https://download.pytorch.org/whl/torchtext-0.13.0-cp310-cp310-linux_x86_64.whl
# from https://download.pytorch.org/whl/torchtext/
RUN pip3 install https://download.pytorch.org/whl/cpu/torchaudio-0.12.0%2Bcpu-cp310-cp310-linux_x86_64.whl
# from https://download.pytorch.org/whl/torchaudio/

RUN pip3 install \
        arrow==1.2.3 \
        lxml==4.9.2 \
        multiprocess==0.70.14 \
        pattern3==3.0.0 \
        pyarrow==11.0.0

RUN pip3 install \
        opencv-python==4.7.0.72

RUN pip3 install \
        auditok==0.2.0 \
        cvxpy==1.3.0 \
        ecos==2.0.12 \
        gensim==4.3.1 \
        networkx==3.0 \
        nltk==3.8.1 \
        osqp==0.6.2.post8 \
        scs==3.2.2

RUN pip3 install \
        anytree==2.8.0 \
        django-file-md5==1.0.3 \
        h5py==3.8.0 \
        jieba==0.42.1 \
        laspy==2.4.1 \
        plotly==5.13.1 \
        plyfile==0.7.4 \
        toolz==0.12.0

RUN pip install \
    "apache-airflow[celery]==2.5.1" \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.1/constraints-3.10.txt"

RUN mv /hadoop-3.3.4/etc/hadoop/log4j.properties /hadoop-3.3.4/etc/hadoop/log4j.properties.bak ;\
    sed /hadoop-3.3.4/etc/hadoop/log4j.properties.bak -e 's/hadoop.root.logger=INFO/hadoop.root.logger=ERROR/' > /hadoop-3.3.4/etc/hadoop/log4j.properties
RUN mkdir /app

COPY ["startup.sh", "/"]
COPY [".bashrc", ".vimrc", "/root/"]
EXPOSE 8080 9090 9999
CMD [ "/bin/bash" ]
