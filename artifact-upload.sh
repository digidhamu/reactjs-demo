#!/bin/bash

# source ./parse-flowref.sh $1

# Get the release tag
TAG_JSON=`curl -skg "https://ctl.daas.digidhamu.com/release-next-tag?stage_uuid=$STAGE_UUID"`

RELEASE_VERSION=`echo $TAG_JSON | jq --raw-output .version`
TAG_LABEL=`echo $TAG_JSON | jq --raw-output .auto_labelling`
BUILD_NUMBER=`echo $TAG_JSON | jq --raw-output .run_count`

IMAGE_TAGGING="v$RELEASE_VERSION-$TAG_LABEL.$BUILD_NUMBER"
echo $IMAGE_TAGGING

./post-progress.sh "$STAGE_UUID" "Taging releasing label" 50
docker tag reactjs-demo dcr.daas.digidhamu.com/reactjs-demo:$IMAGE_TAGGING

./post-progress.sh "$STAGE_UUID" "Push the labelled image" 90
docker push dcr.daas.digidhamu.com/reactjs-demo:$IMAGE_TAGGING
