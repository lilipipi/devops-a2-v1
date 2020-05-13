#!/bin/bash

export endpoint=$(kubectl get service/tech-test-app -o json | jq '.status.loadBalancer.ingress[0].hostname' | sed -e 's/^"//' -e 's/"$//')
echo $endpoint

export returncode=$(curl -s -o /dev/null -w "%{http_code}" ${endpoint})
if [ $returncode -ne "200" ]
then
  echo "Return Code was not 200, it was: ${returncode}"
  exit 1
fi