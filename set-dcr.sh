#!/bin/bash

kubectl config set-context minikube

SECRETNAME=art-pull-sec

kubectl delete secrets $SECRETNAME -n default

kubectl create secret docker-registry $SECRETNAME \
          --docker-server=minikube:32000 \
          --docker-username=$1 \
          --docker-password=$2 \
          --docker-email=$3 \
          -n default
