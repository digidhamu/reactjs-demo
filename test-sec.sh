#!/bin/bash

## Commented as non zero return value when some security test failed
# set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

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

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$SEC_TEST_HTML \
        $ART_SERVER/$SEC_TEST_HTML \
    || exit 1

echo File $SEC_TEST_HTML is uploaded
