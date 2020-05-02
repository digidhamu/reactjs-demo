#!/bin/bash

GITHUB_REPO=reactjs-demo

## Create Pull Request
curl -X "POST" "https://api.github.com/repos/digidhamu/${GITHUB_REPO}/pulls" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $1" \
     -d $'{
  "body": "Please pull these awesome changes in!",
  "title": "Amazing new feature",
  "base": "master",
  "head": "digidhamu:test-pr1"
}'
