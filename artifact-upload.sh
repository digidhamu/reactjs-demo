#!/bin/bash

set -xo errexit # exit immediately on error

source ./set-script-vars.sh $1
source ./get-release-tag.sh $STAGE_UUID

##
# Docker Image Upload
##
./post-progress.sh $STAGE_UUID "Taging releasing label" 50
docker tag reactjs-demo dcr.daas.digidhamu.com/reactjs-demo:$RELEASE_TAG

./post-progress.sh $STAGE_UUID "Push the labelled image" 90
docker push dcr.daas.digidhamu.com/reactjs-demo:$RELEASE_TAG

##
# API Test Result Upload
##
API_TEST_JSON_RELEASE_TAG="api-test-results_$RELEASE_TAG.json"
API_TEST_HTML_RELEASE_TAG="api-test-results_$RELEASE_TAG.html"

cp results/$API_TEST_JSON results/$API_TEST_JSON_RELEASE_TAG
cp results/$API_TEST_HTML results/$API_TEST_HTML_RELEASE_TAG

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_JSON_RELEASE_TAG \
        $ART_SERVER/$API_TEST_JSON_RELEASE_TAG \
    || exit 1

echo File $API_TEST_JSON_RELEASE_TAG is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML_RELEASE_TAG \
        $ART_SERVER/$API_TEST_HTML_RELEASE_TAG \
    || exit 1

echo File $API_TEST_HTML_RELEASE_TAG is uploaded

##
# Functional Test Result Upload
##
FUNC_TEST_MP4_RELEASE_TAG="func-test-results_$RELEASE_TAG.mp4"
cp "results/$FUNC_TEST_MP4" "results/$FUNC_TEST_MP4_RELEASE_TAG"

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4_RELEASE_TAG \
        $ART_SERVER/$FUNC_TEST_MP4_RELEASE_TAG \
    || exit 1

echo File $FUNC_TEST_MP4_RELEASE_TAG is uploaded
