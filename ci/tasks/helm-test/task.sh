#!/usr/bin/env bash

function main() {
  local release_name="${1}"
  clusters="$(pks clusters --json | jq 'sort_by(.name)' | jq -r .[].name)"
  for cluster in ${clusters}; do
    pks get-credentials "${cluster}"

    release="$(helm list -q -f "${release_name}")"
    if [[ -z "${release}" ]]; then
      printf "%s release not found" "${release_name}"
      exit 1
    fi
    
    printf "Testing %s on %s\n" "${release_name}" "${cluster}"
    helm test "${release_name}"

    printf "\nFinished testing %s on %s\n" "${release_name}" "${cluster}"
    printf "============================================================\n"
  done
}

set -e
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail

release="${1:-$RELEASE}"

if [[ -z "${release}" ]]; then
  echo "Release is required"
  exit 1
fi

main "${release}"