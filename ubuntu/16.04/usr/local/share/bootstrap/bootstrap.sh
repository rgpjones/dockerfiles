#!/bin/bash

# Initialisation - Declare variables and run pre-templating steps.
source /usr/local/share/bootstrap/setup.sh

# Initialisation - Runtime installation tasks
shopt -s nullglob
set -- /usr/local/share/container/baseimage-*
if [ "$#" -gt 0 ]; then
  for file in "$@"; do
    # shellcheck source=/dev/null
    source "${file}"
  done
fi

source /usr/local/share/container/plan.sh
if [ -e "$WORK_DIRECTORY/plan.sh" ]; then
  # shellcheck source=/dev/null
  source "$WORK_DIRECTORY/plan.sh"
fi
