#!/bin/bash

# if [[ -z $1 ]]; then
#     echo Required access details is not supplied
#     echo "eg. ./update-pr.sh GITHUB_TOKEN"
#     exit 1
# fi

GITHUB_REPO=reactjs-demo
# GITHUB_TOKEN=$1

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
  "base": "master",
  "head": "digidhamu:test-pr1"
}'
