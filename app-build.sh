#!/bin/bash

set -xo errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Setting up context" 10
kubectl config set-context docker-desktop

./post-progress.sh $STAGE_UUID "Build the docker image" 50
docker build -t $APP_NAME .

./post-progress.sh $STAGE_UUID "Taging build image" 80
docker tag $APP_NAME dcr.daas.digidhamu.com/$APP_NAME:latest

./post-progress.sh $STAGE_UUID "Push the docker images" 90
docker push dcr.daas.digidhamu.com/$APP_NAME:latest
