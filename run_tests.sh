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

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd $THIS_DIR > /dev/null

NUM_TESTS=0
NUM_FAILURES=0

for in_file in tests/*.in; do
    NUM_TESTS=$((NUM_TESTS + 1))
    name="$(basename $in_file)"
    name="${name%.*}"
    echo "Test: $name"
    expected_out_file="${name}.gold"
    out_file="${name}.out"
    ./check_changes_test.sh < "$in_file" > "tests/$out_file" 2>&1 || exit 2
    rc=0
    diff -q "tests/$out_file" "tests/$expected_out_file" || rc=$?
    if [[ $rc != 0 ]]; then
        echo "FAILURE"
        NUM_FAILURES=$((NUM_FAILURES + 1))
    else
        echo "SUCCESS"
    fi
    echo "********************"
done

echo "${NUM_FAILURES}/${NUM_TESTS} tests failed"

popd > /dev/null

rc=0
if [[ $NUM_FAILURES != 0 ]]; then
    rc=1
fi
exit $rc
