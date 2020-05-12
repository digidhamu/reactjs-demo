#!/bin/bash

export API_TEST_JSON="api-test-results.json"
export API_TEST_HTML="api-test-results.html"
export FUNC_TEST_MP4="func-test-results.mp4"
export UX_TEST_HTML="ux-test-results.html"
export SEC_TEST_HTML="sec-test-results.html"
export PERF_TEST_TXT="perf-test-results.txt"

FLOW_REF=$1

echo $FLOW_REF

## Input
# {&quot;flow_id&quot;:&quot;1edf38ca-f03f-482f-a5d9-7dea5d8533d7&quot;,&quot;flow_sequence&quot;:4,&quot;stage_uuid&quot;:&quot;cfecbe6a-0376-4aaa-a48b-f56e4f76af32&quot;}'

FORMATED_JSON=`echo $FLOW_REF | sed 's/&quot;/\"/g'`
echo $FORMATED_JSON

## Output
# {"flow_id":"1edf38ca-f03f-482f-a5d9-7dea5d8533d7","flow_sequence":4,"stage_uuid":"cfecbe6a-0376-4aaa-a48b-f56e4f76af32"}

## --raw-output will remove double quote
export FLOW_ID=`echo $FORMATED_JSON | jq --raw-output .flow_id`
export FLOW_SEQUENCE=`echo $FORMATED_JSON | jq --raw-output .flow_sequence`
export STAGE_UUID=`echo $FORMATED_JSON | jq --raw-output .stage_uuid`

export ART_ACCESS=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/art-access/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

export APP_NAME=$(curl -n -skg "https://ctl.daas.digidhamu.com/app-name?stage_uuid=$STAGE_UUID" \
    --header 'Content-Type: application/json; charset=utf-8' | jq --raw-output .name)

export ART_SERVER_APP_FOLDER_APP_FOLDER="https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/$APP_NAME"
