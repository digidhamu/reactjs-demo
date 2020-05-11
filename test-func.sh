#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

kubectl config set-context docker-desktop

cd e2e
    docker-compose up --exit-code-from cypress
cd ..

sleep 1

cp "e2e/cypress/videos/spec.js.mp4" "results/$FUNC_TEST_MP4"

curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4 \
        $ART_SERVER/$FUNC_TEST_MP4 \
    || exit 1

echo File $FUNC_TEST_MP4 is uploaded
