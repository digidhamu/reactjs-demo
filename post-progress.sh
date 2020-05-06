#!/bin/bash

set +xe

curl -s -X "POST" "https://ctl.daas.digidhamu.com/jcl-script-hook" \
	 -H 'Content-Type: application/json; charset=utf-8' \
	 -d $'{
		"msgStageProgress": {
			"stage_id": '${1}',
			"pipeline_id": '${2}',
			"step_status": "'${3}'",
			"progress_status": '${4}'
		}
	 }'

echo

set -xe
