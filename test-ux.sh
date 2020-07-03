#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Running UX testing" 20
lighthouse http://192.168.64.6:32008 \
    --quiet \
    --chrome-flags="--headless" \
    --output-path=./results/$UX_TEST_HTML

./post-progress.sh $STAGE_UUID "Uploading the latest test results" 80
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$UX_TEST_HTML \
        $ART_SERVER_APP_FOLDER/$UX_TEST_HTML \
    || exit 1

echo File $UX_TEST_HTML is uploaded
