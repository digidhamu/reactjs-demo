#!/bin/bash

# Run lighthouse for UX testing
lighthouse http://192.168.64.32:32008 \
    --quiet \
    --chrome-flags="--headless" \
    --output-path=./results/ux-test-results.html