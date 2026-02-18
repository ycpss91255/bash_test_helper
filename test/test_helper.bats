#!/usr/bin/env bats

setup() {
	# test script path
	TEST_SCRIPT_PATH="${BATS_TEST_DIRNAME}/../src/test_helper.bash"
	source "${TEST_SCRIPT_PATH}"
}

@test "check global variables 'SCRIPT_DIR' is set" {
	[ -n "${SCRIPT_DIR}" ]
}

@test "check global variables 'SCRIPT_DIR' is set" {
	[ -n "${DOCKER_ROOT}" ]
}

@test "check global variables 'SCRIPT_DIR' is set" {
	[ -n "${BATS_LIB_PATH}" ]
}

@test "check global variables 'SCRIPT_DIR' is set" {
	[ -n "${SRC_ROOT}" ]
}
