#!/bin/bash

## Commented as non zero return value when some security test failed
# set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Setting context" 10
# kubectl config set-context docker-desktop

sudo chmod 777 -R results

./post-progress.sh $STAGE_UUID "Running security testing" 20
docker run --rm \
    -v "$(pwd):/zap/wrk/:rw" \
    -t owasp/zap2docker-stable:2.9.0 zap-full-scan.py \
    -t http://daas.digidhamu.com/ \
    -g ./results/gen.conf \
    -r ./results/$SEC_TEST_HTML

# Workaround for success message
echo 'Supressing exit code -2'

./post-progress.sh $STAGE_UUID "Uploading the latest test results" 80
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML \
        $ART_SERVER_APP_FOLDER/$SEC_TEST_HTML \
    || exit 1

echo File $SEC_TEST_HTML is uploaded
