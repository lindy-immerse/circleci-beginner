#!/bin/bash

echo "$PWD"

COVERAGE_FILE=$(cat "../circleci/coverage/circleci/coverage-summary.json" | jq '.')
COVERAGE_STATS=$(echo "$COVERAGE_FILE" | jq '.total')
echo "$COVERAGE_STATS"

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

echo "$JSON" > "$PWD/karma_stats.json"



