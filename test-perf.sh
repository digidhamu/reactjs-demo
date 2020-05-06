#!/bin/bash

set -o errexit # exit immediately on error

if [[ -z $1 || -z $2 ]]; then
    echo Artifacts repo required access details are not supplied
    echo "eg. ./test-perf.sh user password"
    exit 1
fi

ART_USER=$1
ART_PASS=$2

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

PERF_TEST_TXT="perf-test-results.txt"
PERF_TEST_TXT_TIMESTAMP="perf-test-results_$timestamp.txt"

kubectl config set-context docker-desktop

# Run performance testing using k6 docker container
docker run --rm \
    -i loadimpact/k6 \
    run -u 10 -d 30s -< ./perf-test.js > results/perf-test-results.txt

cp "results/$PERF_TEST_TXT" "results/$PERF_TEST_TXT_TIMESTAMP"

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$PERF_TEST_TXT \
        $ART_SERVER/$PERF_TEST_TXT \
    || exit 1

echo File $PERF_TEST_TXT is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$PERF_TEST_TXT_TIMESTAMP \
        $ART_SERVER/$PERF_TEST_TXT_TIMESTAMP \
    || exit 1

echo File $PERF_TEST_TXT_TIMESTAMP is uploaded
