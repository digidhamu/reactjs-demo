#!/bin/bash

set +xe

curl -X "POST" "https://ctl.daas.digidhamu.com/jcl-script-hook" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "msgStageProgress": {
    "stage_uuid": "'"$1"'",
    "step_status": "'"$2"'",
    "progress_status": '$3'
  }
}'

echo

set -xe
