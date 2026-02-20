#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

get_script_dir() {
	local -r script_path="${1:-"${BASH_SOURCE[1]}"}"

	local -r script_dir="$(realpath "$(dirname "${script_path}")")"
	printf '%s' "$script_dir"
}

set_default() {
	local var_name="${1:?"${FUNCNAME[0]} needs var_name"}"
	shift
	local -r default_value="${1:?"${FUNCNAME[0]} needs default_value"}"
	shift

	if [[ -z "${!var_name}" ]]; then
		printf -v "$var_name" "%s" "$default_value"
	fi
}

# ------------------------------ BATS SETUP ------------------------------
bats_load_library "bats-support"
bats_load_library "bats-assert"
bats_load_library "bats-file"

# Default source path for test scripts
# Different internal and external parameters of the container
set_default "PROJECT_ROOT" "${SCRIPT_DIR}/.."
PROJECT_ROOT="$(realpath "${PROJECT_ROOT}")"
set_default "SRC_ROOT" "${PROJECT_ROOT}/src"
set_default "BATS_LIB_PATH" "/usr/lib/bats"

if [ -d "${BATS_TEST_DIRNAME}/lib/bats-mock" ]; then
	load "${BATS_TEST_DIRNAME}/lib/bats-mock/stub"
fi

# load custom libraries
set_default "BATS_CUSTOM_LIB_PATH" "${BATS_TEST_DIRNAME}/lib"
for file in "${BATS_CUSTOM_LIB_PATH}/"*.sh; do
	if [ -f "${file}" ]; then
		# shellcheck disable=SC1090
		source "${file}"
	fi
done
