#!/usr/bin/env bats

setup() {
	local -r relative_test_script_path="../src/test_helper.bash"

	TEST_SCRIPT_PATH="${BATS_TEST_DIRNAME}/${relative_test_script_path}"
	TEST_SCRIPT_PATH="$(realpath "${TEST_SCRIPT_PATH}")"
	source "${TEST_SCRIPT_PATH}"
}

@test "check global variables 'SCRIPT_DIR' is set" {
	[ -n "${SCRIPT_DIR}" ]
}

@test "get_script_dir: should return the directory of the script" {
	local -r expected_dir="$(realpath "${SCRIPT_DIR}")"
	local script_dir=""

	# Test without arguments (returns directory of current caller/script)
	script_dir="$(get_script_dir)"
	[ -d "${script_dir}" ]

	# Test with a specific path
	script_dir="$(get_script_dir "${TEST_SCRIPT_PATH}")"
	script_dir="$(realpath "${script_dir}")"
	[ "${script_dir}" = "${expected_dir}" ]

}

@test "set_default: should set default value if variable is empty" {
	local var=""

	set_default "var" "default_value"
	[ "${var}" = "default_value" ]

	var="already_set"
	set_default "var" "default_value"
	[ "${var}" = "already_set" ]

	set_default "undeclared_var" "success"
	[ "${undeclared_var}" = "success" ]
}

@test "check global variables 'PROJECT_ROOT' is set" {
	[ -n "${PROJECT_ROOT}" ]
	[ -d "${PROJECT_ROOT}" ]
}

@test "check global variables 'SRC_ROOT' is set" {
	[ -n "${SRC_ROOT}" ]
	[ -d "${SRC_ROOT}" ]
}

@test "check global variables 'BATS_CUSTOM_LIB_PATH' is set" {
	[ -n "${BATS_CUSTOM_LIB_PATH}" ]
	[ -d "${BATS_CUSTOM_LIB_PATH}" ]
}

@test "check load custom library" {
	local -r custom_lib_path="${BATS_CUSTOM_LIB_PATH}"

	# create a dummy library to verify it can be loaded
	mkdir -p "${custom_lib_path}"
	echo 'TEST_MARKER="SUCCESS"' > "${custom_lib_path}/verify_load.sh"

	# source the test helper again to load the new library
	source "${TEST_SCRIPT_PATH}"
	[ "${TEST_MARKER}" = "SUCCESS" ]

	# remove the dummy library after the test
	rm "${custom_lib_path}/verify_load.sh"
}
