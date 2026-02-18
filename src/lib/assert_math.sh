#!/bin/bash

assert_greater_than_or_equal() {
  local -r actual="${1}"; shift
  local -r expected="${1}"

  if [ "${actual}" -lt "${expected}" ]; then
    fail "Expected ${actual} to be greater than or equal to ${expected}"
  fi
}

assert_greater_than() {
  local -r actual="${1}"; shift
  local -r expected="${1}"

  if [ "${actual}" -le "${expected}" ]; then
    fail "Expected ${actual} to be strictly greater than ${expected}"
  fi
}

assert_less_than_or_equal() {
  local -r actual="${1}"; shift
  local -r expected="${1}"

  if [ "${actual}" -gt "${expected}" ]; then
    fail "Expected ${actual} to be less than or equal to ${expected}"
  fi
}

assert_less_than() {
  local -r actual="${1}"; shift
  local -r expected="${1}"

  if [ "${actual}" -ge "${expected}" ]; then
    fail "Expected ${actual} to be strictly less than ${expected}"
  fi
}

assert_equal() {
  local -r actual="${1}"; shift
  local -r expected="${1}"

  if [ "${actual}" -ne "${expected}" ]; then
    fail "Expected ${actual} to be equal to ${expected}"
  fi
}

assert_not_equal() {
  local -r actual="${1}"; shift
  local -r expected="${1}"

  if [ "${actual}" -eq "${expected}" ]; then
    fail "Expected ${actual} to not be equal to ${expected}"
  fi
}

assert_between() {
  local -r actual="${1}"; shift
  local -r min="${1}"; shift
  local -r max="${1}"

  if [ "${actual}" -lt "${min}" ] || [ "${actual}" -gt "${max}" ]; then
    fail "Expected ${actual} to be between ${min} and ${max}"
  fi
}

assert_outside() {
  local -r actual="${1}"; shift
  local -r min="${1}"; shift
  local -r max="${1}"

  if [ "${actual}" -ge "${min}" ] && [ "${actual}" -le "${max}" ]; then
    fail "Expected ${actual} to be outside of ${min} and ${max} range"
  fi
}
