#!/bin/bash

curl -v \
    --user "admin:$1" \
    --upload-file ./results/api-test-results.html https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/api-test-results.html

sleep 2

curl -v \
    --user "admin:$1" \
    --upload-file ./results/api-test-results.json https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/api-test-results.json

sleep 2

curl -v \
    --user "admin:$1" \
    --upload-file ./results/perf-test-results.txt https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/perf-test-results.txt

sleep 2

curl -v \
    --user "admin:$1" \
    --upload-file ./results/ux-test-results.html https://art.daas.digidhamu.com/repository/raw-daas-digidhamu/test-results/ux-test-results.html
