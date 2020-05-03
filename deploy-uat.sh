#!/bin/bash

kubectl config set-context minikube

kubectl delete -f reactjs-demo.yaml
sleep 10

kubectl apply -f reactjs-demo.yaml
sleep 10
