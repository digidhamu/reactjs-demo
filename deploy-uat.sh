#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

kubectl config set-context minikube

kubectl delete -f $APP_NAME.yaml
sleep 10

kubectl apply -f $APP_NAME.yaml
sleep 10
