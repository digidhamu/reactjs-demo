#!/bin/bash

set -xo errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Getting the release version" 10
source ./get-release-tag.sh $STAGE_UUID

./post-progress.sh $STAGE_UUID "Setting up context" 20
kubectl config set-context docker-desktop

./post-progress.sh $STAGE_UUID "Updating app to release version" 30
sed -e "s/||appVersion||/${RELEASE_TAG}/" "src/App.js.template" > "src/App.js"

./post-progress.sh $STAGE_UUID "Building the docker image" 50
docker build -t $APP_NAME .

./post-progress.sh $STAGE_UUID "Tagging build image" 80
docker tag $APP_NAME gcr.io/digidhamu-k8s/$APP_NAME:latest

./post-progress.sh $STAGE_UUID "Pushing the docker images" 90
docker push gcr.io/digidhamu-k8s/$APP_NAME:latest
