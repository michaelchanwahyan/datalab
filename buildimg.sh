#!/bin/sh
docker build -t datalab:lightstable ./
docker rmi   -f $(docker images -f "dangling=true" -q)
