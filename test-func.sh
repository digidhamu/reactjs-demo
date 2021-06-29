#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Setting context" 10
# kubectl config set-context docker-desktop

./post-progress.sh $STAGE_UUID "Running functional testing" 20
cd e2e
    docker-compose up --exit-code-from cypress
cd ..

sleep 1

cp "e2e/cypress/videos/spec.js.mp4" "results/$FUNC_TEST_MP4"

./post-progress.sh $STAGE_UUID "Uploading the latest test results" 80
curl \
    --user "$ART_ACCESS" \
    --http1.1 \
    -T ./results/$FUNC_TEST_MP4 \
        $ART_SERVER_APP_FOLDER/$FUNC_TEST_MP4 \
    || exit 1

echo File $FUNC_TEST_MP4 is uploaded
