#!/bin/bash

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Getting the release version" 10
source ./get-release-tag.sh $STAGE_UUID

./post-progress.sh $STAGE_UUID "Updating app to release version" 20
sed -e "s/||appVersion||/${RELEASE_TAG}/" "src/App.js.template" > "src/App.js"

./post-progress.sh $STAGE_UUID "Installing packages" 30
npm install
