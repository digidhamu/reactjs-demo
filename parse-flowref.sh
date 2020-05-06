#!/bin/bash

FLOW_REF=$1

echo $FLOW_REF

# FLOW_REF='{&quot;flow_id&quot;:&quot;8eec3774-9b94-437f-a0c7-582334118921&quot;,&quot;pipeline_id&quot;:2,&quot;flow_sequence&quot;:2,&quot;stage_id&quot;:8}'
# echo '{"flow_id":"8eec3774-9b94-437f-a0c7-582334118921","pipeline_id":2,"flow_sequence":2,"stage_id":8}' | jq .

FORMATED_JSON=`echo $FLOW_REF | sed 's/&quot;/\"/g'`
echo $FORMATED_JSON

## --raw-output will remove double quote
export FLOW_ID=`echo $FORMATED_JSON | jq --raw-output .flow_id`
export PIPELINE_ID=`echo $FORMATED_JSON | jq --raw-output .pipeline_id`
export FLOW_SEQUENCE=`echo $FORMATED_JSON | jq --raw-output .flow_sequence`
export STAGE_ID=`echo $FORMATED_JSON | jq --raw-output .stage_id`
