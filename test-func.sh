#!/bin/bash

set -o errexit # exit immediately on error

if [[ -z $1 || -z $2 ]]; then
    echo Artifacts repo required access details are not supplied
    echo "eg. ./test-func.sh user password"
    exit 1
fi

ART_USER=$1
ART_PASS=$2

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

FUNC_TEST_MP4="func-test-results.mp4"
FUNC_TEST_MP4_TIMESTAMP="func-test-results_$timestamp.mp4"

kubectl config set-context docker-desktop

cd e2e
    docker-compose up --exit-code-from cypress
cd ..

sleep 1

cp "e2e/cypress/videos/spec.js.mp4" "results/$FUNC_TEST_MP4"
cp "results/$FUNC_TEST_MP4" "results/$FUNC_TEST_MP4_TIMESTAMP"

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4 \
        $ART_SERVER/$FUNC_TEST_MP4 \
    || exit 1

echo File $FUNC_TEST_MP4 is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4_TIMESTAMP \
        $ART_SERVER/$FUNC_TEST_MP4_TIMESTAMP \
    || exit 1

echo File $FUNC_TEST_MP4_TIMESTAMP is uploaded
