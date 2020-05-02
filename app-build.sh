#!/bin/bash

kubectl config set-context docker-desktop

docker build -t reactjs-demo .

docker tag reactjs-demo dcr.daas.digidhamu.com/reactjs-demo:latest
docker push dcr.daas.digidhamu.com/reactjs-demo:latest
