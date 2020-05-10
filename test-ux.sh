#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

# Run lighthouse for UX testing
lighthouse http://192.168.64.32:32008 \
    --quiet \
    --chrome-flags="--headless" \
    --output-path=./results/$UX_TEST_HTML

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML \
        $ART_SERVER/$UX_TEST_HTML \
    || exit 1

echo File $UX_TEST_HTML is uploaded
