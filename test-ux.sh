#!/bin/bash
set -o errexit # exit immediately on error

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

ART_ACCESS=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/art-access/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

UX_TEST_HTML="ux-test-results.html"
UX_TEST_HTML_TIMESTAMP="ux-test-results_$timestamp.html"

# Run lighthouse for UX testing
lighthouse http://192.168.64.32:32008 \
    --quiet \
    --chrome-flags="--headless" \
    --output-path=./results/$UX_TEST_HTML

cp "results/$UX_TEST_HTML" "results/$UX_TEST_HTML_TIMESTAMP"

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML \
        $ART_SERVER/$UX_TEST_HTML \
    || exit 1

echo File $UX_TEST_HTML is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML_TIMESTAMP \
        $ART_SERVER/$UX_TEST_HTML_TIMESTAMP \
    || exit 1

echo File $UX_TEST_HTML_TIMESTAMP is uploaded
