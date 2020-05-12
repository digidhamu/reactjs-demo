#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Setting context" 10
kubectl config set-context docker-desktop

./post-progress.sh $STAGE_UUID "Running performance testing" 20
docker run --rm -i loadimpact/k6 \
    run --vus 5 \
    --duration 10s -< ./perf-test.js > results/perf-test-results.txt

# TODO - With Local K6. InfluxDB2 support is not available so far
# k6 run \
#     --vus 5 \
#     --duration 30s \
#     --summary-export=export.json \
#     --out json=myscript-output.json perf-test.js > console.txt

./post-progress.sh $STAGE_UUID "Uploading the latest test results" 80
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$PERF_TEST_TXT \
        $ART_SERVER_APP_FOLDER/$PERF_TEST_TXT \
    || exit 1

echo File $PERF_TEST_TXT is uploaded
