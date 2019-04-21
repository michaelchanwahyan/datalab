#!/bin/sh
docker build -t ds_workspace:stable ./
docker rmi   -f $(docker images -f "dangling=true" -q)
