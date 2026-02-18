#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default source path for test scripts
# Different internal and external parameters of the container
# [ -f "/.dockerenv" ] && DOCKER_ROOT="." || DOCKER_ROOT=".."
DOCKER_ROOT="${SCRIPT_DIR}/.."
BATS_LIB_PATH="${BATS_LIB_PATH:-/usr/lib/bats}"
BATS_LIB_PATH="${BATS_LIB_PATH}:${BATS_TEST_DIRNAME}/lib"
SRC_ROOT="${SRC_ROOT:-${SCRIPT_DIR}/../src}"

bats_load_library "bats-support"
bats_load_library "bats-assert"
bats_load_library "bats-file"

if [ -d "${BATS_LIB_PATH}/bats-mock" ]; then
  load "${BATS_LIB_PATH}/bats-mock/stub"
fi

# # Source: bats folder libraries
for file in "${BATS_TEST_DIRNAME}/lib/"*.sh; do source "${file}"; done
