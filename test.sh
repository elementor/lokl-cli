#!/bin/sh
#
# lokl-go: shell script checker
#
# Tests that all shell scripts in lokl-go are POSIX-compliant and error-free
#
# This doesn't guarantee perfect functionality on every system, but ensures
# the scripts themselves are free of common errors.
#
# License: The Unlicense, https://unlicense.org
#
# Usage: execute this script from the project root
#
#     $   sh tests.sh
#

# run shellcheck against all files in project, excluding .git dir
find . -type f -not -path '*/\.git/*' -name '*.sh' \
  -exec shellcheck {} \;

shellspec --kcov
