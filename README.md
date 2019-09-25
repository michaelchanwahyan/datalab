### Introduction

datalab is a JupyerLab-based open-source platform for scientific research for people of size mild scale team where sharing of code and dataset is allowed. datalab supports Interactive Python (IPython) and R (IR) in which many popular library packages for scientific computation are installed, including NumPy, SciPy, MatPlotLib, scikit-learn, and more tools for statistical research. There are also Tensorflow and Keras for users who love playing deep learning charm and AI magic.

We also introduce Spark+Hadoop as a good infrastructure for intensive computation so that users receive benefit wherever highend performance machine is available. There are many more tools listed in those requirements files.

An automatic job scheduling tool named 'apache-airflow' is also prepared, although my primary preference always goes to 'cron' because simplicity is beauty.

datalab hopes users can save time in establishing a JupyterLab platform with many tools ready.

### Usage (core)

To turn on the docker image and start JupyerLab:

if you pull the image from docker hub (see remark 1):

`docker run -dt -p 9999:9999 michaelchanwahyan/datalab:latest jupyter lab --ip=0.0.0.0 --port=9999 --no-browser --notebook-dir=/app --allow-root --NotebookApp.token='yourpassword'`; or

if you build the image from source (see remark 2):

`docker run -dt -p 9999:9999 datalab:stable jupyter lab --ip=0.0.0.0 --port=9999 --no-browser --notebook-dir=/app --allow-root --NotebookApp.token='yourpassword'`; or

if you want full usage on JupyterLab and Apache-Airflow and Docker-Volume mounting, see `startup.sh` and below Useful Resources below.

### Useful Resources
- #### [Installation](https://github.com/michaelchanwahyan/datalab/wiki/Installation)
- #### [First Project](https://github.com/michaelchanwahyan/datalab/wiki/First-project)
- #### [Set Schedule](https://github.com/michaelchanwahyan/datalab/wiki/Set-Schedule)


##### Remark 1:

This docker image is available in https://hub.docker.com/r/michaelchanwahyan/datalab

You may get it by `docker pull michaelchanwahyan/datalab:latest`

note: currently it points to the branch `dockerbuild-trigger`

##### Remark 2:

To download this repo and build it on your own, you may want to

`git clone -b dockerbuild-trigger --recurse-submodule https://github.com/michaelchanwahyan/datalab.git`

`cd datalab`

`bash buildimg.sh # note: it helps clean out dangling docker imgaes !`

### Contributed by:

- Michael https://github.com/michaelchanwahyan
- Icarus https://github.com/IcarusSO
