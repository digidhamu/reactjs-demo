#!/bin/bash

set -o errexit # exit immediately on error

source ./set-script-vars $1

GITHUB_REPO=$APP_NAME

GITHUB_TOKEN=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/github-token/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

## Create Pull Request
curl -X "POST" "https://api.github.com/repos/digidhamu/${GITHUB_REPO}/pulls" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $GITHUB_TOKEN" \
     -d $'{
  "body": "Please pull these awesome changes in!",
  "title": "Amazing new feature",
  "base": "develop",
  "head": "digidhamu:test-pr1"
}'
