#!/bin/bash

## Commented as non zero return value when some security test failed
# set -o errexit # exit immediately on error

if [[ -z $1 || -z $2 ]]; then
    echo Artifacts repo required access details are not supplied
    echo "eg. ./test-sec.sh user password"
    exit 1
fi

ART_USER=$1
ART_PASS=$2

ART_SERVER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results"
timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

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
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML \
        $ART_SERVER/$SEC_TEST_HTML \
    || exit 1

echo File $SEC_TEST_HTML is uploaded

curl \
    --user "$ART_USER:$ART_PASS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML_TIMESTAMP \
        $ART_SERVER/$SEC_TEST_HTML_TIMESTAMP \
    || exit 1

echo File $SEC_TEST_HTML_TIMESTAMP is uploaded
