#!/bin/bash

# this has yet to be tested

set -euo pipefail

function main() {
  kubectl apply -f configmap.yaml
  kubectl apply -f daemonset.yaml
  wait_for_pods ssm-agent-installer
  wait_for_success ssm-agent-installer
  kubectl delete -f daemonset.yaml
}

function wait_for_pods() {
  echo -n "waiting for $1 pods to run"

  PODS=$(kubectl get pods | grep $1 | awk '{print $1}')

  for POD in ${PODS}; do
    while [[ $(kubectl get pod ${POD} -o go-template --template "{{.status.phase}}") != "Running" ]]; do
      sleep 1
      echo -n "."
    done
  done

  echo
}

function wait_for_success() {
  echo -n "waiting for $1 daemonset to complete"

  PODS=$(kubectl get pods | grep $1 | awk '{print $1}')

  for POD in ${PODS}; do
    while [[ $(kubectl logs ${POD} --tail 1) != "Success" ]]; do
      sleep 1
      echo -n "."
    done
    
    # at this point you could take the output of kubectl logs and do something with it
  done

  echo
}

main