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

FUNC_TEST_MP4="func-test-results.mp4"
FUNC_TEST_MP4_TIMESTAMP="func-test-results_$timestamp.mp4"

kubectl config set-context docker-desktop

cd e2e
    docker-compose up --exit-code-from cypress
cd ..

sleep 5

cp "e2e/cypress/videos/spec.js.mp4" "results/$FUNC_TEST_MP4"
cp "results/$FUNC_TEST_MP4" "results/$FUNC_TEST_MP4_TIMESTAMP"

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4 \
        $ART_SERVER/$FUNC_TEST_MP4 \
    || exit 1

echo File $FUNC_TEST_MP4 is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4_TIMESTAMP \
        $ART_SERVER/$FUNC_TEST_MP4_TIMESTAMP \
    || exit 1

echo File $FUNC_TEST_MP4_TIMESTAMP is uploaded
