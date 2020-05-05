#!/bin/bash

kubectl config set-context minikube

SECRETNAME=art-pull-sec

kubectl delete secrets $SECRETNAME

kubectl create secret docker-registry $SECRETNAME \
          --docker-server=minikube:32000 \
          --docker-username=admin \
          --docker-password=$1 \
          --docker-email=$2
