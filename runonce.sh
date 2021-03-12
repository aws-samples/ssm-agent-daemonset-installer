#!/bin/bash

# this has yet to be tested

set -euo pipefail

function main() {
  kubectl apply -f configmap.yaml
  kubectl apply -f daemonset.yaml

  local -r DAEMONSET_NAME="ssm-agent-installer"
  local -r PODS="$(kubectl get pods | grep -i "${DAEMONSET_NAME}" | awk '{print $1}')"
  
  wait_for_pods
  wait_for_success

  kubectl delete -f daemonset.yaml
}

function wait_for_pods() {
  echo -n "waiting for ${DAEMONSET_NAME} pods to run"

  for POD in ${PODS}; do
    while [[ "$(kubectl get pod "${POD}" -o go-template --template "{{.status.phase}}")" != "Running" ]]; do
      sleep 1
      echo -n "."
    done
  done

  echo
}

function wait_for_success() {
  echo -n "waiting for ${DAEMONSET_NAME} daemonset to complete"

  for POD in ${PODS}; do
    while [[ $(kubectl logs "${POD}" --tail 1) != "Success" ]]; do
      sleep 1
      echo -n "."
    done
    
    # at this point you could take the output of kubectl logs and do something with it
  done

  echo
}

main