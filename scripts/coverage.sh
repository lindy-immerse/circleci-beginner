#!/bin/bash

##------ GET CURRENT COVERAGE ------##

COVERAGE_FILE=$(cat "../circleci/coverage/circleci/coverage-summary.json" | jq '.')
COVERAGE_STATS=$(echo "$COVERAGE_FILE" | jq '.total')

LINES=$(echo "$COVERAGE_STATS" | jq '.lines.pct')
STATEMENTS=$(echo "$COVERAGE_STATS" | jq '.statements.pct')
FUNCTIONS=$(echo "$COVERAGE_STATS" | jq '.functions.pct')
BRANCHES=$(echo "$COVERAGE_STATS" | jq '.branches.pct')

CURRENT_THRESHOLD=$(jq -n \
        --arg lines "$LINES" \
        --arg statements "$STATEMENTS" \
        --arg functions "$FUNCTIONS" \
        --arg branches "$BRANCHES" \
        '{lines: $lines, statements: $statements, functions: $functions, branches: $branches}')

##------ DETERMINE NEW THRESHOLD ------##

THRESHOLD="{"
count=0

ARTIFACT=$(cat "./data/karma_threshold.json" | jq '.')
echo "$ARTIFACT"

for key in $(echo $CURRENT_THRESHOLD | jq -r 'keys[]'); do
    CURRENT_VALUE=$(echo $CURRENT_THRESHOLD | jq -r --arg key "$key" '.[$key]')
    PREVIOUS_VALUE=$(echo $ARTIFACT | jq -r --arg key "$key" '.[$key]')

    if [[ $count != 0 ]]; then
        THRESHOLD="${THRESHOLD},"
    fi

    if [[ "$CURRENT_VALUE" > "$PREVIOUS_VALUE" ]];
    then
        THRESHOLD="${THRESHOLD}\n\"$key\": $CURRENT_VALUE"
    else
        THRESHOLD="${THRESHOLD}\n\"$key\": $PREVIOUS_VALUE"
    fi

    ((count=count+1))
done

THRESHOLD="${THRESHOLD}\n}"
THRESHOLD_JS="module.exports = ${THRESHOLD};"

##------ SAVE NEW THRESHOLD ------##

echo -e "$THRESHOLD" > "$PWD/data/karma_threshold.json"
echo -e "$THRESHOLD_JS" > "$PWD/data/karma_threshold.js"
