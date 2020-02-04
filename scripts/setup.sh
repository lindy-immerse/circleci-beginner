#!/bin/bash

##------ PULL THRESHOLD ARTIFACT ------##

PIPELINES=$(curl -L "https://circleci.com/api/v2/project/github/lindy-immerse/circleci-beginner/pipeline?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
PREVIOUS_PIPELINE_ID=$(echo "$PIPELINES" | jq '.items' | jq '.[0]' | jq -r '.id')
PREVIOUS_WORKFLOWS=$(curl -L "https://circleci.com/api/v2/pipeline/$PREVIOUS_PIPELINE_ID/workflow?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
PREVIOUS_WORKFLOW_ID=$(echo "$PREVIOUS_WORKFLOWS" | jq '.items' | jq '.[0]' | jq -r '.id')
PREVIOUS_JOBS=$(curl -L "https://circleci.com/api/v2/workflow/$PREVIOUS_WORKFLOW_ID/job?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
JOB_NUMBER=$(echo "$PREVIOUS_JOBS" | jq '.items' | jq '.[] | select(.name=="angular_testing")' | jq -r '.job_number')
#JOB_NUMBER=96
ARTIFACTS=$(curl -L "https://circleci.com/api/v2/project/github/lindy-immerse/circleci-beginner/$JOB_NUMBER/artifacts?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")

NUM_ARTIFACTS=$(echo $ARTIFACTS | jq '.items' | jq length)

if [[ $NUM_ARTIFACTS == 0 ]];
then
    echo "ZERO!!!!!!!"
    THRESHOLD=0
    JSON="{\n\"branches\": $THRESHOLD,\n\"functions\": $THRESHOLD,\n\"lines\": $THRESHOLD,\n\"statements\": $THRESHOLD\n}"
    echo -e "$JSON"
    echo -e "$JSON" > "$PWD/data/karma_threshold.json"
    echo -e "module.exports=$JSON;" > "$PWD/data/karma_threshold.js"
else
    echo "NOT ZERO!!!!!!!"
    ARTIFACT_URL=$(echo "$ARTIFACTS" | jq '.items' | jq '.[0]' | jq -r '.url')

    if [[ $ARTIFACT_URL == *".json"* ]];
    then
        ARTIFACT=$(curl -L $ARTIFACT_URL)
    else
        ARTIFACT_URL=$(echo "$ARTIFACTS" | jq '.items' | jq '.[1]' | jq -r '.url')
        ARTIFACT=$(curl -L $ARTIFACT_URL)
    fi

    echo -e "$ARTIFACT"
    echo -e "$ARTIFACT" > "$PWD/data/karma_threshold.json"
    echo -e "module.exports=$ARTIFACT;" > "$PWD/data/karma_threshold.js"
fi
