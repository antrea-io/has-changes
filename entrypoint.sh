#!/usr/bin/env bash
# Copyright 2022 Antrea Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

read -r -a PATTERNS <<< "$1"
read -r -a IGNORE_PATTERNS <<< "$2"

echo "PATHS: ${PATTERNS[@]}"
echo "IGNORE_PATHS: ${IGNORE_PATTERNS[@]}"

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $THIS_DIR/check_changes.sh

cat "$GITHUB_EVENT_PATH"

PR_BASE_SHA=$(jq -r '.pull_request.base.sha' "$GITHUB_EVENT_PATH")
BEFORE=$(jq -r '.before' "$GITHUB_EVENT_PATH")
if [[ $PR_BASE_SHA != "" && $PR_BASE_SHA != "null" ]]; then # PR events
    SHA=$PR_BASE_SHA
elif [[ $BEFORE != "" && $BEFORE != "null" ]]; then # push events
    SHA=$BEFORE
else
    echo "This does not appear to be a PR or a push event"
    echo "Setting 'has_changes' to 'yes'"
    echo "::set-output name=has_changes::yes"
    exit 0
fi
echo "BASE SHA: $SHA"

CHANGED_FILES=$(git diff --name-only "$SHA" HEAD) || rc=$?

if [[ $rc -ne 0 ]]; then
    echo "Error when running 'git diff'"
    echo "This is expected when the repo was not checked-out properly, or after a force push"
    echo "Setting 'has_changes' to 'yes'"
    echo "::set-output name=has_changes::yes"
    exit 0
fi

has_changes=$(check_changes "$CHANGED_FILES" "${PATTERNS[*]}" "${IGNORE_PATTERNS[*]}")

if $has_changes; then
    echo "Setting 'has_changes' to 'yes'"
    echo "::set-output name=has_changes::yes"
else
    echo "Setting 'has_changes' to 'no'"
    echo "::set-output name=has_changes::no"
fi
