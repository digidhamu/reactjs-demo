#!/bin/bash

kubectl config set-context minikube

kubectl delete -f reactjs-demo.yaml
kubectl apply -f reactjs-demo.yaml

sleep 30