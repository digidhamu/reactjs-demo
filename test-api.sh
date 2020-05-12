#!/bin/bash

set -xo errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Running API testing" 10
newman run api-test.json \
    --insecure \
    --reporters cli,json,html \
    --reporter-json-export results/$API_TEST_JSON \
    --reporter-html-export results/$API_TEST_HTML

./post-progress.sh $STAGE_UUID "Uploading the latest test results" 50
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_JSON \
        $ART_SERVER/$API_TEST_JSON \
    || exit 1

echo File $API_TEST_JSON is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML \
        $ART_SERVER/$API_TEST_HTML \
    || exit 1

echo File $API_TEST_HTML is uploaded
