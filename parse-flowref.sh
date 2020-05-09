#!/bin/bash

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
