#!/bin/bash

kubectl config set-context docker-desktop

# Run performance testing using k6 docker container
docker run -i loadimpact/k6 run -u 10 -d 30s -< ./perf-test.js > results/perf-test-results.txt
