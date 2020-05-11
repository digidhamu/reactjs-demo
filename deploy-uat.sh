#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

kubectl config set-context minikube

kubectl delete -f $APP_NAME.yaml
sleep 10

kubectl apply -f $APP_NAME.yaml
sleep 10

# docker pull dcr.daas.digidhamu.com/reactjs-demo:ui-enhancement_v1.1.0-alpha.1
# echo "ui-enhancement_v1.1.0-alpha.1" | tr '_' $'\n'