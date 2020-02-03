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

##------ PULL COVERAGE ARTIFACT ------##

ARTIFACT=$(curl -L "https://circleci.com/api/v1.1/project/github/lindy-immerse/circleci-beginner/latest/artifacts?circle-token=b045cdea55d0e571a208181e4366f4c62c4016ce")
echo "$ARTIFACT"

##------ GET NEW COVERAGE ------##

EPOCH_TIME=$(date +%s)
echo "$JSON" > "$PWD/data/karma_stats_$EPOCH_TIME.json"
echo "$JSON"
