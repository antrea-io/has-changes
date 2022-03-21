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

check_changes() {
    local globbing_enabled=true
    if [ -o noglob ]; then
        globbing_enabled=false
    else
        set -o noglob
    fi

    local changed_files="$1"
    local patterns="$2"
    local ignore_patterns="$3"

    >&2 echo "* Changed files are:"
    >&2 echo "$changed_files"

    local changed_files_1=()
    for changed_file in $changed_files; do
        matched=false
        for pattern in $patterns; do
            if [[ "$changed_file" == $pattern ]]; then
                matched=true
                break
            fi
        done
        if $matched; then
            changed_files_1+=("$changed_file")
        fi
    done
    changed_files_1="${changed_files_1[@]}"

    >&2 echo "* Changed files after filtering with patterns are:"
    >&2 echo "$changed_files_1"

    local changed_files_2=()
    has_changes=false
    for changed_file in $changed_files_1; do
        matched=false
        for pattern in $ignore_patterns; do
            if [[ "$changed_file" == $pattern ]]; then
                matched=true
                break
            fi
        done
        if ! $matched; then
            changed_files_2+=("$changed_file")
            has_changes=true
        fi
    done
    changed_files_2="${changed_files_2[@]}"

    >&2 echo "* Changed files after filtering with ignore_patterns are:"
    >&2 echo "$changed_files_2"

    if $globbing_enabled; then
        set +o noglob
    fi

    echo $has_changes
}
