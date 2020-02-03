#!/bin/bash

##------ GET CURRENT COVERAGE ------##

COVERAGE_FILE=$(cat "../circleci/coverage/circleci/coverage-summary.json" | jq '.')
COVERAGE_STATS=$(echo "$COVERAGE_FILE" | jq '.total')

LINES=$(echo "$COVERAGE_STATS" | jq '.lines.pct')
STATEMENTS=$(echo "$COVERAGE_STATS" | jq '.statements.pct')
FUNCTIONS=$(echo "$COVERAGE_STATS" | jq '.functions.pct')
BRANCHES=$(echo "$COVERAGE_STATS" | jq '.branches.pct')

JSON=$(jq -n \
        --arg lines "$LINES" \
        --arg statements "$STATEMENTS" \
        --arg functions "$FUNCTIONS" \
        --arg branches "$BRANCHES" \
        '{lines: $lines, statements: $statements, functions: $functions, branches: $branches}')

##------ PULL THRESHOLD ARTIFACT ------##

PIPELINES=$(curl -L "https://circleci.com/api/v2/project/github/lindy-immerse/circleci-beginner/pipeline?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
PREVIOUS_PIPELINE_ID=$(echo "$PIPELINES" | jq '.items' | jq '.[1]' | jq -r '.id')
PREVIOUS_WORKFLOWS=$(curl -L "https://circleci.com/api/v2/pipeline/$PREVIOUS_PIPELINE_ID/workflow?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
PREVIOUS_WORKFLOW_ID=$(echo "$PREVIOUS_WORKFLOWS" | jq '.items' | jq '.[0]' | jq -r '.id')
PREVIOUS_JOBS=$(curl -L "https://circleci.com/api/v2/workflow/$PREVIOUS_WORKFLOW_ID/job?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
JOB_NUMBER=$(echo "$PREVIOUS_JOBS" | jq '.items' | jq '.[] | select(.name=="angular_testing")' | jq -r '.job_number')
ARTIFACT_DETAILS=$(curl -L "https://circleci.com/api/v2/project/github/lindy-immerse/circleci-beginner/$JOB_NUMBER/artifacts?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
ARTIFACT_URL=$(echo "$ARTIFACT_DETAILS" | jq '.items' | jq '.[0]' | jq -r '.url')
ARTIFACT=$(curl -L $ARTIFACT_URL)

echo -e "\n"
echo "---> LATEST PIPELINE ---> $LATEST_PIPELINE_ID"
echo "---> LATEST WORKFLOW ---> $LATEST_WORKFLOW_ID"
echo "---> JOB NUMBER ---> $JOB_NUMBER"
echo "---> ARTIFACT URL ---> $ARTIFACT_URL"
echo -e "---> ARTIFACT\n$ARTIFACT"
echo -e "\n"

##------ DETERMINE NEW THRESHOLD ------##

##------ SAVE NEW THRESHOLD ------##


EPOCH_TIME=$(date +%s)
echo "$JSON" > "$PWD/data/karma_stats_$EPOCH_TIME.json"
#echo "$JSON"
