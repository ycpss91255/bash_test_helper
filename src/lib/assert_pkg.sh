#!/bin/bash

assert_version_at_least() {
  local -r pkg_version="${1}"; shift
  local -r min_version="${1}"; shift

  local -r pkg_major=$(echo "$pkg_version" | cut -d. -f1)
  local -r pkg_minor=$(echo "$pkg_version" | cut -d. -f2)
  local -r pkg_patch=$(echo "$pkg_version" | cut -d. -f3)

  local -r min_major=$(echo "$min_version" | cut -d. -f1)
  local -r min_minor=$(echo "$min_version" | cut -d. -f2)
  local -r min_patch=$(echo "$min_version" | cut -d. -f3)

  if (( pkg_major > min_major )); then
    return 0
  elif (( pkg_major == min_major && pkg_minor > min_minor )); then
    return 0
  elif (( pkg_major == min_major && pkg_minor == min_minor && pkg_patch >= min_patch )); then
    return 0
  fi

  fail "Package version '${pkg_version}' is less than minimum required version '${min_version}'"
}
