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

PERF_TEST_TXT="perf-test-results.txt"
PERF_TEST_TXT_TIMESTAMP="perf-test-results_$timestamp.txt"

kubectl config set-context docker-desktop

# Run performance testing using k6 docker container
docker run --rm \
    -i loadimpact/k6 \
    run -u 10 -d 30s -< ./perf-test.js > results/perf-test-results.txt

cp "results/$PERF_TEST_TXT" "results/$PERF_TEST_TXT_TIMESTAMP"

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$PERF_TEST_TXT \
        $ART_SERVER/$PERF_TEST_TXT \
    || exit 1

echo File $PERF_TEST_TXT is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$PERF_TEST_TXT_TIMESTAMP \
        $ART_SERVER/$PERF_TEST_TXT_TIMESTAMP \
    || exit 1

echo File $PERF_TEST_TXT_TIMESTAMP is uploaded
