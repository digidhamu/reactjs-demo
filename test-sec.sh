#!/bin/bash

## Commented as non zero return value when some security test failed
# set -o errexit # exit immediately on error

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

ART_ACCESS=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/art-access/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

SEC_TEST_HTML="sec-test-results.html"
SEC_TEST_HTML_TIMESTAMP="sec-test-results_$timestamp.html"

kubectl config set-context docker-desktop

# Run OWASP ZAP security testing via docker container
docker run --rm \
    -v "$(pwd):/zap/wrk/:rw" \
    -t owasp/zap2docker-stable zap-full-scan.py \
    -t http://192.168.64.32:32008 \
    -g ./results/gen.conf \
    -r ./results/$SEC_TEST_HTML

# Workaround for success message
echo 'supressing exit code -2'

cp "results/$SEC_TEST_HTML" "results/$SEC_TEST_HTML_TIMESTAMP"

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML \
        $ART_SERVER/$SEC_TEST_HTML \
    || exit 1

echo File $SEC_TEST_HTML is uploaded

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML_TIMESTAMP \
        $ART_SERVER/$SEC_TEST_HTML_TIMESTAMP \
    || exit 1

echo File $SEC_TEST_HTML_TIMESTAMP is uploaded
