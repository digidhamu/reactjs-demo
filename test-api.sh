#!/bin/bash

set -xo errexit # exit immediately on error

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

ART_ACCESS=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/art-access/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

API_TEST_JSON="api-test-results.json"
API_TEST_HTML="api-test-results.html"
API_TEST_JSON_TIMESTAMP="api-test-results_$timestamp.json"
API_TEST_HTML_TIMESTAMP="api-test-results_$timestamp.html"

newman run api-test.json \
    --insecure \
    --reporters cli,json,html \
    --reporter-json-export results/$API_TEST_JSON \
    --reporter-html-export results/$API_TEST_HTML

cp results/$API_TEST_JSON results/$API_TEST_JSON_TIMESTAMP
cp results/$API_TEST_HTML results/$API_TEST_HTML_TIMESTAMP

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
    -T ./results/$API_TEST_JSON_TIMESTAMP \
        $ART_SERVER/$API_TEST_JSON_TIMESTAMP \
    || exit 1

echo File $API_TEST_JSON_TIMESTAMP is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML \
        $ART_SERVER/$API_TEST_HTML \
    || exit 1

echo File $API_TEST_HTML is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML_TIMESTAMP \
        $ART_SERVER/$API_TEST_HTML_TIMESTAMP \
    || exit 1

echo File $API_TEST_HTML_TIMESTAMP is uploaded
