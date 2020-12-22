#!/bin/bash

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Running unit test" 10
npm run test-cover
