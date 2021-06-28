#!/bin/bash

set -xo errexit # exit immediately on error

source ./set-script-vars.sh $1
source ./get-release-tag.sh $STAGE_UUID

##
# Docker Image Upload
##
./post-progress.sh $STAGE_UUID "Taging releasing label" 10
docker tag $APP_NAME gcr.io/digidhamu-k8s/$APP_NAME:$RELEASE_TAG

./post-progress.sh $STAGE_UUID "Push the labelled image" 20
docker push gcr.io/digidhamu-k8s/$APP_NAME:$RELEASE_TAG

export DATE_TIME=`date "+%Y-%m-%d %H:%M:%S.%3N"`

generate_post_data()
{
  cat <<EOF
{
  "action": "CREATED",
  "component": {
    "id": "08909bf0c86cf6c9600aade89e1c5e25",
    "version": "$RELEASE_TAG",
    "name": "$APP_NAME",
    "format": "docker"
  },
  "timestamp": "$DATE_TIME",
  "initiator": "dhamukrish",
  "repositoryName": "gcr.io"
}
EOF
}

curl -X "POST" "https://ctl.daas.digidhamu.com/nr-dcr-comps-hook" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d "$(generate_post_data)"

##
# API Test Result Upload
##
API_TEST_JSON_RELEASE_TAG="api-test-results_${RELEASE_TAG}.json"
API_TEST_HTML_RELEASE_TAG="api-test-results_${RELEASE_TAG}.html"

cp results/$API_TEST_JSON results/$API_TEST_JSON_RELEASE_TAG
cp results/$API_TEST_HTML results/$API_TEST_HTML_RELEASE_TAG

./post-progress.sh $STAGE_UUID "Uploading API test results" 40
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_JSON_RELEASE_TAG \
        $ART_SERVER_APP_FOLDER/$API_TEST_JSON_RELEASE_TAG \
    || exit 1

echo File $API_TEST_JSON_RELEASE_TAG is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML_RELEASE_TAG \
        $ART_SERVER_APP_FOLDER/$API_TEST_HTML_RELEASE_TAG \
    || exit 1

echo File $API_TEST_HTML_RELEASE_TAG is uploaded

##
# Functional Test Result Upload
##
FUNC_TEST_MP4_RELEASE_TAG="func-test-results_${RELEASE_TAG}.mp4"
cp "results/$FUNC_TEST_MP4" "results/$FUNC_TEST_MP4_RELEASE_TAG"

./post-progress.sh $STAGE_UUID "Uploading functional test results" 60
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4_RELEASE_TAG \
        $ART_SERVER_APP_FOLDER/$FUNC_TEST_MP4_RELEASE_TAG \
    || exit 1

echo File $FUNC_TEST_MP4_RELEASE_TAG is uploaded

##
# UX Test Result Upload
##
UX_TEST_HTML_RELEASE_TAG="ux-test-results_${RELEASE_TAG}.html"
cp "results/$UX_TEST_HTML" "results/$UX_TEST_HTML_RELEASE_TAG"

./post-progress.sh $STAGE_UUID "Uploading UX test results" 70
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML_RELEASE_TAG \
        $ART_SERVER_APP_FOLDER/$UX_TEST_HTML_RELEASE_TAG \
    || exit 1

echo File $UX_TEST_HTML_RELEASE_TAG is uploaded

##
# Security Test Result Upload
##
SEC_TEST_HTML_RELEASE_TAG="sec-test-results_${RELEASE_TAG}.html"
cp "results/$SEC_TEST_HTML" "results/$SEC_TEST_HTML_RELEASE_TAG"

./post-progress.sh $STAGE_UUID "Uploading security test results" 80
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML_RELEASE_TAG \
        $ART_SERVER_APP_FOLDER/$SEC_TEST_HTML_RELEASE_TAG \
    || exit 1

echo File $SEC_TEST_HTML_RELEASE_TAG is uploaded


##
# Performance Test Result Upload
##
PERF_TEST_TXT_RELEASE_TAG="perf-test-results_${RELEASE_TAG}.txt"
cp "results/$PERF_TEST_TXT" "results/$PERF_TEST_TXT_RELEASE_TAG"

./post-progress.sh $STAGE_UUID "Uploading performance test results" 90
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$PERF_TEST_TXT_RELEASE_TAG \
        $ART_SERVER_APP_FOLDER/$PERF_TEST_TXT_RELEASE_TAG \
    || exit 1

echo File $PERF_TEST_TXT_RELEASE_TAG is uploaded
