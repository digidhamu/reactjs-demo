#!/bin/bash

source ./parse-flowref.sh $1

source ./get-release-tag.sh $STAGE_UUID

./post-progress.sh $STAGE_UUID "Taging releasing label" 50
docker tag reactjs-demo dcr.daas.digidhamu.com/reactjs-demo:$RELEASE_TAG

./post-progress.sh $STAGE_UUID "Push the labelled image" 90
docker push dcr.daas.digidhamu.com/reactjs-demo:$RELEASE_TAG
