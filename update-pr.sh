#!/bin/bash
export PATH="$PATH:/Users/dhamukrish/Documents/digidhamu/k8s.do.digidhamu.com/tools/sonar-scanner-4.2.0.1873-macosx/bin"

if [[ -z $1 ]]; then
    echo GitHub issue/pull request number is not supplied
    echo "eg. ./update-pr.sh 1"
    exit 1
fi

SONAR_HOST=https://cdq.daas.digidhamu.com
SONAR_PROJECT_KEY=reactjs-daas-demo
SONAR_PROJECT_NAME=$SONAR_PROJECT_KEY
GITHUB_REPO=reactjs-demo
GITHUB_ISSUE=$1

GITHUB_TOKEN=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/github-token/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

SONAR_API_TOKEN=$(curl -n -skg "https://secretmanager.googleapis.com/v1/projects/202626771609/secrets/sonar-token/versions/1:access" \
    --request "GET" \
    --header "authorization: Bearer $(gcloud auth print-access-token)" \
    --header "content-type: application/json" \
    --header "x-goog-user-project: digidhamu-k8s" \
    | jq -r ".payload.data" | base64 --decode)

sonar-scanner -Dsonar.host.url=$SONAR_HOST \
              -Dsonar.projectKey=$SONAR_PROJECT_KEY \
              -Dsonar.projectName=$SONAR_PROJECT_NAME \
              -Dsonar.projectVersion=1.0 \
              -Dsonar.sources=. \
              -Dsonar.login=$SONAR_API_TOKEN \
              -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
              -Dsonar.exclusions=**/node_modules/**,**/coverage/lcov-report/**,**/serviceWorker.js,**/*.test.js

echo "Checking if analysis is finished.."

SONAR_STATUS_URL=$(cat .scannerwork/report-task.txt | grep ceTaskUrl | sed -e 's/ceTaskUrl=//')
SONAR_STATUS=$(curl -skg "${SONAR_STATUS_URL}" | sed -e 's/.*status":"//' | sed -e 's/",.*//')

while ! [ "${SONAR_STATUS}" = "SUCCESS" ] || [ "${SONAR_STATUS}" = "CANCELED" ] || [ "${SONAR_STATUS}" = "FAILED" ];
do                                    
    echo "Sonar analysis is: ${SONAR_STATUS}. Taking a nap while we wait..."
    sleep 5
    SONAR_STATUS=$(curl -skg ${SONAR_STATUS_URL} | sed -e 's/.*status":"//' | sed -e 's/",.*//')                    
done

echo "Sonar task returned: ${SONAR_STATUS}"

if [ "${SONAR_STATUS}" = "FAILED" ]; then                
 exit 1
fi

echo "Checking status of analysis with sonar key: ${SONAR_PROJECT_KEY}"

SONAR_QG_STATUS=$(curl -skg "https://cdq.daas.digidhamu.com/api/qualitygates/project_status?projectKey=${SONAR_PROJECT_KEY}" -u "${SONAR_API_TOKEN}:")

echo "Sonar WEB API returned:"
echo "${SONAR_QG_STATUS}"


if [[ ${SONAR_QG_STATUS} == *'{"projectStatus":{"status":"ERROR",'* ]]; then
    echo Qualiaty gate status: FAILED

    ## Pull Request Comments
    curl -X "POST" "https://api.github.com/repos/digidhamu/${GITHUB_REPO}/issues/${GITHUB_ISSUE}/comments" \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -d $"{
            \"body\": \"Sonar Quality Gate is **failed**. [${SONAR_PROJECT_KEY}](https://cdq.daas.digidhamu.com/dashboard?id=${SONAR_PROJECT_KEY})\"
        }"
    exit 1
fi

echo Qualiaty gate status: PASSED

## Pull Request Comments
curl -X "POST" "https://api.github.com/repos/digidhamu/${GITHUB_REPO}/issues/${GITHUB_ISSUE}/comments" \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -d $"{
        \"body\": \"Sonar Quality Gate is passed. [${SONAR_PROJECT_KEY}](https://cdq.daas.digidhamu.com/dashboard?id=${SONAR_PROJECT_KEY})\"
    }"

exit 0
