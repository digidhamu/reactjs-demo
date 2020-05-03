#!/bin/bash

newman run api-test.json \
    --insecure \
    --reporters cli,json,html \
    --reporter-json-export results/api-test-results.json \
    --reporter-html-export results/api-test-results.html
