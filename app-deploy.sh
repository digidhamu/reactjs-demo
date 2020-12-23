#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Setting up context" 10
kubectl config set-context minikube

./post-progress.sh $STAGE_UUID "Uninstalling app" 20
kubectl delete -f $APP_NAME.yaml
sleep 10

./post-progress.sh $STAGE_UUID "Installing app" 70
kubectl apply -f $APP_NAME.yaml
sleep 10
