#!/bin/sh
docker build -t datalab:stable ./
docker rmi   -f $(docker images -f "dangling=true" -q)
