#!/bin/bash

source ./parse-flowref.sh $1

./post-progress.sh $STAGE_ID $PIPELINE_ID "setting-up-context" 10
kubectl config set-context docker-desktop

./post-progress.sh $STAGE_ID $PIPELINE_ID "build-the-docker-image" 50
docker build -t reactjs-demo .

./post-progress.sh $STAGE_ID $PIPELINE_ID "taging-build-image" 80
docker tag reactjs-demo dcr.daas.digidhamu.com/reactjs-demo:latest

./post-progress.sh $STAGE_ID $PIPELINE_ID "push-the-docker-images" 90
docker push dcr.daas.digidhamu.com/reactjs-demo:latest
