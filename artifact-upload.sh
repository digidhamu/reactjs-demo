#!/bin/bash

export timestamp=`date +%Y-%m-%d"_"%H_%M_%S`

ART_PASS=$1

API_TEST_HTML="api-test-results.html"
API_TEST_JSON="api-test-results.json"
FUNC_TEST_MP4="func-test-results.mp4"
UX_TEST_HTML="ux-test-results.html"
SEC_TEST_HTML="sec-test-results.html"
PERF_TEST_TXT="perf-test-results.txt"

tar -czvf \
    ./results_${timestamp}.tar.gz \
    ./results/* \
    || exit 1

sleep 5

if [[ -f "./results_${timestamp}.tar.gz" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T ./results_${timestamp}.tar.gz \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/results_${timestamp}.tar.gz \
        || exit 1

    echo "File results_${timestamp}.tar.gz is uploaded"
else
    echo "File results_${timestamp}.tar.gz is not present"
fi

sleep 5

if [[ -f "./results/$API_TEST_HTML" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T ./results/$API_TEST_HTML \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$API_TEST_HTML \
        || exit 1

    echo "File $API_TEST_HTML is uploaded"    
else
    echo "File $API_TEST_HTML is not present"
fi

sleep 5

if [[ -f "./results/$API_TEST_JSON" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T ./results/$API_TEST_JSON \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$API_TEST_JSON \
        || exit 1
    
    echo "File $API_TEST_JSON is uploaded"
else
    echo "File $API_TEST_JSON is not present"
fi

sleep 5

cp ./e2e/cypress/videos/spec.js.mp4 ./results/$FUNC_TEST_MP4

sleep 10

if [[ -f "./results/$FUNC_TEST_MP4" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T ./results/$FUNC_TEST_MP4 \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$FUNC_TEST_MP4 \
        || exit 1

    echo "File $FUNC_TEST_MP4 is uploaded"
else
    echo "File $FUNC_TEST_MP4 is not present"
fi

sleep 5

if [[ -f "./results/$UX_TEST_HTML" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T ./results/$UX_TEST_HTML \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$UX_TEST_HTML \
        || exit 1

    echo "File $UX_TEST_HTML is uploaded"
else
    echo "File $UX_TEST_HTML is not present"
fi

sleep 5

if [[ -f "./results/$SEC_TEST_HTML" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T "./results/$SEC_TEST_HTML" \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$SEC_TEST_HTML \
        || exit 1

    echo "File $SEC_TEST_HTML is uploaded"
else
    echo "File $SEC_TEST_HTML is not present"
fi

sleep 5

if [[ -f "./results/$PERF_TEST_TXT" ]]; then
    curl \
        --user "admin:$ART_PASS" \
        --http1.1 \
        -T ./results/$PERF_TEST_TXT \
            https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$PERF_TEST_TXT \
        || exit 1

    echo "File $PERF_TEST_TXT is uploaded"
else
    echo "File $PERF_TEST_TXT is not present"
fi

## Clean up
rm -f ./results_*
