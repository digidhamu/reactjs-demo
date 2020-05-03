#!/bin/bash

export timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

ART_PASS=$1

tar -czvf \
    ./results_${timestamp}.tar.gz \
    ./results/* \
    || exit 1

sleep 2

curl -v \
    --user "admin:$ART_PASS" \
    --upload-file ./results_${timestamp}.tar.gz \
        https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/results_${timestamp}.tar.gz \
    || exit 1

sleep 2

curl -v \
    --user "admin:$ART_PASS" \
    --upload-file ./results/api-test-results.html \
        https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/api-test-results.html \
    || exit 1

sleep 2

curl -v \
    --user "admin:$ART_PASS" \
    --upload-file ./results/api-test-results.json \
        https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/api-test-results.json \
    || exit 1
  
sleep 2

curl -v \
    --user "admin:$ART_PASS" \
    --upload-file ./results/ux-test-results.html \
        https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/ux-test-results.html \
    || exit 1

sleep 2

curl -v \
    --user "admin:$ART_PASS" \
    --upload-file ./results/sec-test-results.html \
        https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/sec-test-results.html \
    || exit 1

sleep 2

curl -v \
    --user "admin:$ART_PASS" \
    --upload-file ./results/perf-test-results.txt \
        https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/perf-test-results.txt \
    || exit 1

## Clean up
rm -f ./results_*
