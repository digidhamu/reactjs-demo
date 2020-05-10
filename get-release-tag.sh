#!/bin/bash

STAGE_UUID=$1

# Get the release tag
TAG_JSON=`curl -skg "https://ctl.daas.digidhamu.com/release-next-tag?stage_uuid=$STAGE_UUID"`

RELEASE_VERSION=`echo $TAG_JSON | jq --raw-output .version`
TAG_LABEL=`echo $TAG_JSON | jq --raw-output .auto_labelling`
BUILD_NUMBER=`echo $TAG_JSON | jq --raw-output .run_count`

export RELEASE_TAG="v$RELEASE_VERSION-$TAG_LABEL.$BUILD_NUMBER"
echo $RELEASE_TAG
