#!/bin/bash

source ./set-script-vars.sh $1

./post-progress.sh $STAGE_UUID "Installing packages" 10
npm install
