#!/bin/bash

source ./parse-flowref.sh $1

# Get the release tag
echo `curl "https://ctl.daas.digidhamu.com/release-next-tag?stage_uuid=$STAGE_UUID"` | jq .

./post-progress.sh "$STAGE_UUID" "Taging releasing label" 50
docker tag reactjs-demo dcr.daas.digidhamu.com/reactjs-demo:latest

./post-progress.sh "$STAGE_UUID" "Push the labelled image" 90
docker push dcr.daas.digidhamu.com/reactjs-demo:latest
