#!/bin/bash

set -xo errexit # exit immediately on error

source ./set-script-vars.sh $1

newman run api-test.json \
    --insecure \
    --reporters cli,json,html \
    --reporter-json-export results/$API_TEST_JSON \
    --reporter-html-export results/$API_TEST_HTML

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
