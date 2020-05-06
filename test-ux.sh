#!/bin/bash
set -o errexit # exit immediately on error

if [[ -z $1 || -z $2 ]]; then
    echo Artifacts repo required access details are not supplied
    echo "eg. ./test-ux.sh user password"
    exit 1
fi

ART_USER=$1
ART_PASS=$2

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

UX_TEST_HTML="ux-test-results.html"
UX_TEST_HTML_TIMESTAMP="ux-test-results_$timestamp.html"

# Run lighthouse for UX testing
lighthouse http://192.168.64.32:32008 \
    --quiet \
    --chrome-flags="--headless" \
    --output-path=./results/$UX_TEST_HTML

cp "results/$UX_TEST_HTML" "results/$UX_TEST_HTML_TIMESTAMP"

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML \
        $ART_SERVER/$UX_TEST_HTML \
    || exit 1

echo File $UX_TEST_HTML is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML_TIMESTAMP \
        $ART_SERVER/$UX_TEST_HTML_TIMESTAMP \
    || exit 1

echo File $UX_TEST_HTML_TIMESTAMP is uploaded
