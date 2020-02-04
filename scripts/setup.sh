#!/bin/bash

##------ CHECK IF karma_stats.js EXISTS ------##

FILE=$PWD/data/karma_stats.js
THRESHOLD=0

##------ PULL THRESHOLD ARTIFACT ------##

PIPELINES=$(curl -L "https://circleci.com/api/v2/project/github/lindy-immerse/circleci-beginner/pipeline?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
PREVIOUS_PIPELINE_ID=$(echo "$PIPELINES" | jq '.items' | jq '.[1]' | jq -r '.id')
PREVIOUS_WORKFLOWS=$(curl -L "https://circleci.com/api/v2/pipeline/$PREVIOUS_PIPELINE_ID/workflow?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
PREVIOUS_WORKFLOW_ID=$(echo "$PREVIOUS_WORKFLOWS" | jq '.items' | jq '.[0]' | jq -r '.id')
PREVIOUS_JOBS=$(curl -L "https://circleci.com/api/v2/workflow/$PREVIOUS_WORKFLOW_ID/job?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
JOB_NUMBER=$(echo "$PREVIOUS_JOBS" | jq '.items' | jq '.[] | select(.name=="angular_testing")' | jq -r '.job_number')
ARTIFACTS=$(curl -L "https://circleci.com/api/v2/project/github/lindy-immerse/circleci-beginner/$JOB_NUMBER/artifacts?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
ARTIFACT_URL=$(echo "$ARTIFACTS" | jq '.items' | jq '.[1]' | jq -r '.url')
ARTIFACT=$(curl -L $ARTIFACT_URL)

#if test ! -f "$FILE";
#then
#    KARMA_JS="module.exports = {\n\"branches\": $THRESHOLD,\n\"functions\": $THRESHOLD,\n\"lines\": $THRESHOLD,\n\"statements\": $THRESHOLD\n};"
#    echo -e "$KARMA_JS" > "$PWD/data/karma_stats.js"
#    echo "---> Generated karma_stats.js!"
#else
#    echo "---> File karma_stats.js already exists."
#fi
