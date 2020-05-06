#!/bin/bash

set -xo errexit # exit immediately on error

if [[ -z $1 || -z $2 ]]; then
    echo Artifacts repo required access details are not supplied
    echo "eg. ./test-api.sh user password"
    exit 1
fi

ART_USER=$1
ART_PASS=$2

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

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
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$API_TEST_JSON \
        $ART_SERVER/$API_TEST_JSON \
    || exit 1

echo File $API_TEST_JSON is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$API_TEST_JSON_TIMESTAMP \
        $ART_SERVER/$API_TEST_JSON_TIMESTAMP \
    || exit 1

echo File $API_TEST_JSON_TIMESTAMP is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML \
        $ART_SERVER/$API_TEST_HTML \
    || exit 1

echo File $API_TEST_HTML is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$API_TEST_HTML_TIMESTAMP \
        $ART_SERVER/$API_TEST_HTML_TIMESTAMP \
    || exit 1

echo File $API_TEST_HTML_TIMESTAMP is uploaded
